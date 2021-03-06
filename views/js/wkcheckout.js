/**
 * 2010-2020 Webkul.
 *
 * NOTICE OF LICENSE
 *
 * All right is reserved,
 * Please go through this link for complete license : https://store.webkul.com/license.html
 *
 * DISCLAIMER
 *
 * Do not edit or add to this file if you wish to upgrade this module to newer
 * versions in the future. If you wish to customize this module for your
 * needs please refer to https://store.webkul.com/customisation-guidelines/ for more information.
 *
 *  @author    Webkul IN <support@webkul.com>
 *  @copyright 2010-2020 Webkul IN
 *  @license   https://store.webkul.com/license.html
 */

$(document).ready(function() {

    $('#wk_login_pop').on('shown.bs.modal', function () {
        $('#wk-login-email').focus();
    });
    // refresh cart information when customer/visitor vist the cart page
    updateOrderSummary().then(function(ordersummaryresponse){
        if (ordersummaryresponse) {
            updateShippingorPayment();
        }
    });
    $('#pay-with-payment-option-2-form').hide();
    $('#wk-payment-confirmation button').attr('id', 'fechar-compra');

    function validateZipCodeByShipping() {
        if ($('#hook-display-after-carrier').children('.wkalert').length > 0){
            // $('#zipvalidatorhide').hide();
            return false;
        } else {
            return true;
        }
    }

    //---------------------------------------------------------------------

    // $(document).ajaxSend(function() {
    //     showCustomerLoader();
    // });

    // $(document).ajaxStop(function() {
    //     hideCustomerLoader();
    // });

    $(document).on('blur', '#delivery_message', function() {
        if (id_cart) {
            $.ajax({
                type: 'POST',
                url: wkcheckout,
                async: false,
                data: {
                    'ajax': true,
                    'id_cart': id_cart,
                    'id_customer': id_customer,
                    'token': wktoken,
                    'message': $('#delivery_message').val(),
                    'action': 'addDeliveryMessage',
                },
                success: function(result) {
                    Window.token = result;
                },
            });
        }
    });

    //	Show login pop for guest
    $(document).on('click', '.wkbtn-login', function() {
        $('#wk_login_pop').modal('show');

        $("#wk-login-email").keyup();
    });

    //	If guest want to create account then show password input field
    $(document).on('click', '#wk-create-account', function() {
        if ($(this).is(":checked")) {
            $('.wkpassword_div').show();
        } else {
            $('.wkpassword_div').hide();
        }
    });

    //	Process login
    $(document).on('submit', '#wk-login-form', function(e) {
        e.preventDefault();
        var params = $('#wk-login-form').serialize();
        loginSubmit('validateLogin', params, 'login');
    });

    //	Validate email enter by guest
    $(document).on('blur', '#wk-email', function() {
        if (validateGuestEmail()) {
            var email = $('#wk-email').val();
            /* Adriana - 08/04/2021 - in??cio */
            email = email.trim();
            $('#wk-email').val(email);
            /* Adriana - 08/04/2021 - fim */
            if ($('#wk-create-account').is(":checked")) {
                var is_guest = 0;
            } else {
                var is_guest = 1;
            }
            checkEmailExist(email, is_guest);
        }
    });

    //	Validate password enter by guest
    $(document).on('blur', '#wk-password', function() {
        validatePassword();
    });

    // As soon as customer/vistor chnage the shipping , refresh payment method accordingly
    $(document).on('change', '.wk_selected_shipping', function() {
        var idCarrier = $(this).val();
        var idCountry = false;
        var selectedDeliveryAddress = $('input[name=wk-delivery-address]:checked').val();

        $('.wk-shipping-info').removeClass('wkSelectedBorder');
        if (typeof selectedDeliveryAddress === 'undefined') {
            idCountry = $('select[name=wk_delivery_address_country] option:selected').val();
        }
        idCarrier = idCarrier.replace(/.$/,""); // .$ always pick the last char of string
        setDeliveryMethod(idCarrier, idCountry, true, false);
        $('.wk-selected-shipping-' + idCarrier).addClass('wkSelectedBorder');
        window.location.reload(true);
    });

    $(document).on('change', 'input[name=payment-option]', function() {
        $('.wk-payment-info').removeClass('wkSelectedBorder');
        $('.wk-selected-payment-' + $(this).attr('id')).addClass('wkSelectedBorder');
        $('#' + $(this).attr('id') + '-additional-information').css({'display': 'inline-block'});
    });

    $(document).on('change', 'input[name="wk-delivery-address"]', function() {
        showNewDeliveryAddress($(this).val());
    });

    $(document).on('change', 'input[name="wk-invoice-address"]', function() {
        showInvoiceAddress($(this).val());
        var idCountry = $('select[name=wk_invoice_address_country] option:selected').val();
        getStateByIdCountry(idCountry, 'invoice');
    });

    $(document).on('change', '#wk-existing-delivery-address', function() {
        var idAddress = $(this).val();
        if ($('input[name="wk-different-invoice"]').is(":checked")) {
            var idAddressInvoice = idAddress;
        } else {
            var idAddressInvoice = $('#wk-existing-invoice-address option:selected').val();
        }
        updateCustomerAddress(idAddress, idAddressInvoice, 'delivery', true, true);
    });

    $(document).on('change', '#wk-existing-invoice-address', function() {
        var idAddressInvoice = $(this).val();
        if ($('input[name="wk-different-invoice"]').is(":checked")) {
            var idAddress = idAddressInvoice;
        } else {
            var idAddress = $('#wk-existing-delivery-address option:selected').val();
        }
        updateCustomerAddress(idAddress, idAddressInvoice, 'invoice', true, true);
    });

    //	Increase product quantity into the cart
    $(document).on('click', '.wk-qty-up', function() {
        var obj = $(this);
        var currentQty = $(this).parent().siblings('input.wk-hidden-qty').val();
        currentQty = parseInt(currentQty) + 1;
        // $(this).parent().siblings('input.wk-qty').val(currentQty);
        changeCartQuantity(obj, 'updateQty', 'up', 1, false);
    });

    //	Decrease product quantity from the cart
    $(document).on('click', '.wk-qty-down', function() {
        var obj = $(this);
        var currentQty = $(this).parent().siblings('input.wk-hidden-qty').val();
        currentQty = parseInt(currentQty) - 1;
        // $(this).parent().siblings('input.wk-qty').val(currentQty);

        changeCartQuantity(obj, 'updateQty', 'down', 1, false);
    });

    $(document).on('blur', 'input[name=wk-cart-qty]', function() {
        $('.wkorder_error').hide().text('');
        var obj = $(this);
        var inputQty = $(this).val();
        var idProduct = $(this).attr('data-id-product');
        var idProductAttribute = $(this).attr('data-id-product-attribute');
        var currentQty = $('input[data-id-product=' + idProduct + '][data-id-product-attribute=' + idProductAttribute + ']').val();

        if (inputQty < 0) {
            $('.wkorder_error').show().text(qty_less);
            return false;
        } else if (inputQty > currentQty) {
            var condition = 'up';
        } else if (inputQty < currentQty) {
            var condition = 'down';
        }
        changeCartQuantity(obj, 'updateQty', condition, Math.abs(inputQty - currentQty), true);
    });

    //	Delete product from the cart
    $(document).on('click', '#wk-remove-cart', function() {
        var obj = $(this);
        changeCartQuantity(obj, 'deleteCartProduct', false, false, false);
        window.location.reload(true);
    });

    //	Disabled invoice tab in case delivery address selected same as invoice
    $(document).on('click', 'input[name="wk-different-invoice"]', function() {
        if ($(this).is(":checked")) {
            $('.wk-disabled-invoice').addClass('disabled');
            $('.wk-disabled-invoice a').removeAttr('data-toggle');
        } else {
            $('.wk-disabled-invoice').removeClass('disabled');
            $('.wk-disabled-invoice a').attr('data-toggle', 'tab');
        }
    });

    //	Disabled invoice tab in case delivery address selected same as invoice
    $(document).on('click', '#wk_new_invoice_address', function() {
        if ($(this).is(":checked")) {
            $('.wk-new-invoice').addClass('disabled');
            $('.wk-new-invoice a').removeAttr('data-toggle');
        } else {
            $('.wk-new-invoice').removeClass('disabled');
            $('.wk-new-invoice a').attr('data-toggle', 'tab');
        }
    });

    //	Add available voucher on cart
    $(document).on('click', '#addVoucher', function() {
        var discountName = $('#wk-voucher').val();
        addVoucherOnCart(discountName);
    });

    //	Delete applied voucher from the cart
    $(document).on('click', '#wk-delete-voucher', function() {
        var idVoucher = $(this).attr('data-id');
        if (idVoucher) {
            deleteCartVoucher(idVoucher)
        }
    });

    //	On changing country get states based on country
    $(document).on('change', '.wk_address_country', function() {
        var idCountry = $(this).val();
        var dataAttr = $(this).attr('data-attr');
        getStateByIdCountry(idCountry, dataAttr);
    });

    //	On changing state update carrier/payment methods
    $(document).on('change', '.wk_address_state', function() {
        var idCountry = $('.wk_address_country option:selected').val();
        var idState = $(this).val();
        var dataAttr = $(this).attr('data-attr');
        if (dataAttr == 'delivery') {
            updateShippingMethod(1, idCountry, idState).then(function(updateshippingresponse){
                if (updateshippingresponse) {
                    updatePaymentMethod(0, idCountry, 0);
                }
            });
        }
    });

    if (typeof address_exist === 'undefined') {
        // On load check delivery selected country
        var idCountry = $('.wk_address_country option:selected').val();
        var dataAttr = 'delivery';
        getStateByIdCountry(idCountry, dataAttr);

        // On load check invoice selected country
        var idCountry = $('select[name=wk_invoice_address_country] option:selected').val();
        var dataAttr = 'invoice';
        getStateByIdCountry(idCountry, dataAttr);
    }

    //	Validate delivery and invoice address field
    $(document).on('blur', '.wkvalidatefield', function() {
        if (typeof inline !== 'undefined') {
            var fieldValue = $.trim($(this).val());
            var fieldId = $(this).attr('id');
            var maxlength = $(this).attr('maxlength');
            var required = $(this).attr('data-required');
            var fieldValidation = $(this).attr('data-validate');

            if (!fieldValue) {
                if (required == 1) {
                    $('#' + fieldId).addClass('border-error').removeClass('border-success');
                    $('.error_' + fieldId).addClass('wkshow').removeClass('wkhide');
                    $('.icon_' + fieldId).addClass('wkhide').removeClass('wkshow');
                }
            } else {
                /* Adriana - 15/07/2020 - in??cio */
                /*if (typeof maxlength !== 'undefinded') {*/
                if (typeof maxlength !== 'undefined') {
                /* Adriana - 15/07/2020 - fim */
                    if (fieldValue.length > maxlength) {
                        $('#' + fieldId).addClass('border-error').removeClass('border-success');
                        $('.error_' + fieldId).addClass('wkshow').removeClass('wkhide');
                        $('.icon_' + fieldId).addClass('wkhide').removeClass('wkshow');
                        $('.' + fieldId).text(error_length);
                    } else {
                        if (fieldId == 'wk_delivery_address_zip') {
                            var idCountry = $('select[name=wk_delivery_address_country] option:selected').val();
                            /* Adriana - 31/05/2021 - in??cio */
                            fieldValue = fieldValue.replace("-","");
                            /* Adriana - 31/05/2021 - fim */
                            validatePostalCode(fieldValue, fieldId, idCountry);
                        } else if (fieldId == 'wk_invoice_address_zip') {
                            var idCountry = $('select[name=wk_invoice_address_country] option:selected').val();
                            /* Adriana - 31/05/2021 - in??cio */
                            fieldValue = fieldValue.replace("-","");
                            /* Adriana - 31/05/2021 - fim */
                            validatePostalCode(fieldValue, fieldId, idCountry);
                        } else {
                            validateAddressField(fieldValue, fieldId, fieldValidation, maxlength, required);
                        }
                    }
                } else {
                    validateAddressField(fieldValue, fieldId, fieldValidation, maxlength, required);
                }
            }
        }
    });

    //	Save customer delivery and invoice address by clicking on save button
    $(document).on('click', '.wk-save-address', function(e) {
        e.preventDefault();
        var dataType = $(this).attr('data-type');
        $('#wk-msg-new' + dataType).hide().text('');
        if (dataType == 'delivery') {
            var formData = $('#wk-delivery-form').serialize();
        } else if (dataType == 'invoice') {
            var formData = $('#wk-invoice-form').serialize();
        }
        var no_error = true;

        if (wk_is_logged == 0 && customer_is_guest == 0) {
            no_error = validateGuestEmail();
            if (no_error == true) {
                var email = $('#wk-email').val();
                /* Adriana - 08/04/2021 - in??cio */
                email = email.trim();
                $('#wk-email').val(email);
                /* Adriana - 08/04/2021 - fim */
                if ($('#wk-create-account').is(":checked")) {
                    var is_guest = 0;
                } else {
                    var is_guest = 1;
                }
                no_error = checkEmailExist(email, is_guest);

                if (no_error == true) {
                    var isValidated = validateDeliveryFormData(formData, dataType);
                    if (isValidated) {
                        wknewtoken = createAccount();
                        if (wknewtoken) {
                            //update token
                            wktoken = wknewtoken;
                            wk_is_logged = 1;
                            if (is_guest == 1) {
                                customer_is_guest = 1;
                            } else {
                                customer_is_guest = 0;
                            }
                        } else {
                            no_error = false;
                        }
                    } else {
                        no_error = false;
                    }
                }
            }
        } else {
            var isValidated = validateDeliveryFormData(formData, dataType);
            if (!isValidated) {
                no_error = false;
            } else {
                no_error = true;
            }
        }

        if (no_error == true) {
            var isCreated = createNewAddress(formData, dataType, true, true, false);
            if (isCreated) {
                $('#wk-msg-new-' + dataType).show().text(wk_add_success).addClass('wksuccesscolor');
                window.location.reload(true);
            } else {
                $('#wk-msg-new-' + dataType).show().text(wk_add_failed).addClass('wkerrorcolor');
            }
        }
    });

    //	Add voucher code into input box
    $(document).on('click', '#wkadd-code', function() {
        $('#wk-voucher').attr('value', $(this).text());
    });

    // check if payment method is checked or not
    var paymentChecked = $('input[name=payment-option]:checked').attr('id');
    //$('#' + paymentChecked + '-additional-information').show();
    $('#' + paymentChecked + '-additional-information').css({'display': 'inline-block'});

    //	By selecting terms and condition make payment button enabled
    $(document).on('click', '.wk-condition-check', function() {
        if ($(this).is(':checked')) {
            $('#wk-payment-confirmation button').removeAttr('disabled');
        } else {
            $('#wk-payment-confirmation button').attr('disabled', 'disabled');
        }
    });

    // On quick view, proceed to checkout will reload the page on order controller
    $(document).on('click', 'div.cart-content-btn a', function(event) {
        event.preventDefault();
        window.location.href = wkorder;
    });

    // on quick view, if customer choose to continue shopping then redirect to home page
    $(document).on('click', 'div.cart-content-btn button', function(event) {
        window.location.href = wkhome;
    });

    // change image when customer open modal box to view product image in large size
    $(document).on('click', '.js-modal-thumb', function(event) {
        if ($('.js-modal-thumb').hasClass('selected')) {
            $('.js-modal-thumb').removeClass('selected');
        }
        $(event.currentTarget).addClass('selected');
        var idProduct = $(event.currentTarget).attr('data-id-product');
        $('.js-modal-product-cover-' + idProduct).attr('src', $(event.target).data('image-large-src'));
        $('.js-modal-product-cover-' + idProduct).attr('title', $(event.target).attr('title'));
        $('.js-modal-product-cover-' + idProduct).attr('alt', $(event.target).attr('alt'));
    });

    // Add product into cart when customer click on add to cart from below of cart page
    $(document).on('click', '[data-button-action="wk-add-to-cart"]', function(event) {
        var idProduct = $(this).attr('data-id-product');
        var idProductAttribute = $(this).attr('data-id-product-attribute');
        addProductIntoCart(idProduct, idProductAttribute);
    });

    // save cart when customer click on save cart icon from cart detail page
    $(document).on('click', '#wk-cart-save', function() {
        var obj = $(this);
        if (saveCart(obj, 'saveCartProduct', false, false)) {
            changeCartQuantity(obj, 'deleteCartProduct', false, false, false);
            window.location.reload(true);
        }
    });

    // Final payment process
    $(document).on('click', '#wk-payment-confirmation button', function() {

        var stepGuest = stepAddress = stepShipping = stepPayment = stepCustomer = stepDeliveryDateAndTime = stepZipValidator = true;
        if (wk_is_logged == 0) {
            stepGuest = validateGuestOrNewCustomer();
            if (!stepGuest) {
                $('html, body').animate({
                    scrollTop: ($('#wk-email').offset().top - 200)
                }, 2000);
                return false;
            }
        }

        stepAddress = validateCustomerAddress();
        if (!stepAddress) {
            $('html, body').animate({
                scrollTop: ($('#wk_delivery_first_name, #wk_invoice_first_name').offset().top - 80)
            }, 2000);
            return false;
        }

        stepOrderSummary = validateOrderSummary();
        if (!stepOrderSummary) {
            $('html, body').animate({
                scrollTop: ($('#wk-order-summary-ajax').offset().top - 80)
            }, 2000);
            return false;
        }

        stepShipping = validateShippingSelection();
        if (!stepShipping) {
            $.growl.error({ title: "", message: no_shipping_select, size : "large", duration : 10000 });
            return false;
        }

        stepZipValidator = validateZipCodeByShipping();
        if (!stepZipValidator) {
            $('html, body').animate({
                scrollTop: ($('#hook-display-after-carrier').offset().top - 80)
            }, 2000);
            return false;
        }

        stepPayment = validatePaymentSelection();
        if (!stepPayment) {
            /* Adriana - 15/07/2020 - in??cio */
            /*
            $('#wkpayment-error').show().text(wk_payment_err);
            $('html, body').animate({
                scrollTop: ($('.wk-payment-icon').offset().top - 10)
            }, 2000);
            $.growl.error({ title: "", message: no_payment_select});
            */
            /* Adriana - 15/07/2020 - fim */
            return false;
        }

        if (wk_is_logged == 0 && customer_is_guest == 0) {
            wknewtoken = createAccount();
            if (!wknewtoken) {
                return false;
            }
        }
        if (typeof wknewtoken === 'undefined') {
            wknewtoken = wktoken;
        }

        stepCustomer = createCustomerAddress(wknewtoken);
        if (!stepCustomer) {
            wkShowError(address_failed);
            return false;
        }

        var shippingMethodWithComma = $('input:radio.wk_selected_shipping:checked').val();
        var shippingMethod = removeCommaFromShipping(shippingMethodWithComma);
        if (typeof shippingMethod !== 'undefined') {
            stepCarrier = setDeliveryMethod(shippingMethod, false, false, wknewtoken);
            if (!stepCarrier) {
                $('#wkshipping-error').show().text(no_shipping_select); //	Shipping is not updated
                $('html, body').animate({
                    scrollTop: ($('.wk-shipping-icon').offset().top - 10)
                }, 2000);
                return false;
            }
        }

        stepDeliveryDateAndTime = validateDeliveryDateAndTime();
        if (!stepDeliveryDateAndTime) {
            $('html, body').animate({
                scrollTop: ($('#ddw_calendar, #ddw_timeslots').offset().top - 80)
            }, 2000);
            return false;
        }

        $('#wkpayment-error, #wkshipping-error').hide().text('');
        makePayment();
        return false;

    });

    if (typeof noAddress !== 'undefined') {
        showNewDeliveryAddress(2);
    }
});

function wkShowError(msg) {
    $.growl.error({ title: "", message: msg});
}

function wkShowSuccess(msg) {
    $.growl.notice({ title: "", message: msg});
}

function validateGuestOrNewCustomer() {
    if (validateGuestEmail()) {
        var wk_day = $('select[name=wk_day]').val();
        var wk_month = $('select[name=wk_month]').val();
        var wk_year = $('select[name=wk_year]').val();

        if (typeof wk_day !== 'undefined' || typeof wk_month !== 'undefined' || typeof wk_year !== 'undefined') {
            if (wk_day == 0 && wk_month == 0 && wk_year == 0) {
                $('#wk_day').removeClass('border-error');
                $('#wk_month').removeClass('border-error');
                $('#wk_year').removeClass('border-error');
            } else if (wk_day > 0 && wk_month > 0 && wk_year > 0) {
                $('#wk_day').removeClass('border-error');
                $('#wk_month').removeClass('border-error');
                $('#wk_year').removeClass('border-error');
            } else if (!wk_day) {
                $('#wk_day').addClass('border-error');
                $('#wk_month').removeClass('border-error');
                $('#wk_year').removeClass('border-error');
                return false;
            } else if (!wk_month) {
                $('#wk_day').removeClass('border-error');
                $('#wk_month').addClass('border-error');
                $('#wk_year').removeClass('border-error');
                return false;
            } else if (!wk_year) {
                $('#wk_day').removeClass('border-error');
                $('#wk_month').removeClass('border-error');
                $('#wk_year').addClass('border-error');
                return false;
            } else {
                $('#wk_day').removeClass('border-error');
                $('#wk_month').removeClass('border-error');
                $('#wk_year').removeClass('border-error');
            }
        } else {
            $('#wk_day').removeClass('border-error');
            $('#wk_month').removeClass('border-error');
            $('#wk_year').removeClass('border-error');
        }

        var create_account = 0;
        if ($('#wk-create-account').is(":checked")) {
            var create_account = 1;
        }
        /* Adriana - 08/04/2021 - in??cio */
        //if (checkEmailExist($('#wk-email').val(), create_account)) {
        var email = $('#wk-email').val();
        email = email.trim();
        $('#wk-email').val(email);
        if (checkEmailExist($('#wk-email').val(), create_account)) {
        /* Adriana - 08/04/2021 - fim */
            if (create_account) {
                if (validatePassword()) {
                    return true;
                } else {
                    return false;
                }
            } else {
                return true;
            }
        } else {
            return false;
        }
    } else {
        return false;
    }
}

function validateGuestEmail() {
    $('#wk-email-error').text('');
    var email = $('#wk-email').val();
    /* Adriana - 08/04/2021 - in??cio */
    $('.error_wk_email').hide();
    $('.icon_wk_email').show();
    $('#wk-email').removeClass('border-error').addClass('border-success');
    email = email.trim();
    $('#wk-email').val(email);
    /* Adriana - 08/04/2021 - fim */

    if (!email) {
        $('#wk-email').addClass('border-error');
        $('#wk-email-error').text(email_required);
        $('.error_wk_email').show();
        return false;
    } else if (!ValidateEmail(email)) {
        $('#wk-email').addClass('border-error');
        $('#wk-email-error').text(email_error);
        $('.error_wk_email').show();
        return false;
    } else if (email.length > 128) {
        $('#wk-email').addClass('border-error');
        $('#wk-email-error').text(email_length);
        $('.error_wk_email').show();
        return false;
    } else {
        /* Adriana - 08/04/2021 - in??cio */
        $('#wk-email-error').text('');
        /* Adriana - 08/04/2021 - fim */
        $('.error_wk_email').hide();
        $('.icon_wk_email').show();
        $('#wk-email').removeClass('border-error').addClass('border-success');
        return true;
    }
}

function validatePassword() {
    $('#wk-password').removeClass('border-error, border-success');
    $('.error_wk_password, .icon_wk_password').hide();
    var password = $('#wk-password').val();
    if (!password) {
        $('#wk-password').addClass('border-error');
        $('#wk-password-error').text(password_required);
        $('#wk-password-error').show();
        $('.error_wk_password').show();
        return false;
    } else if (password.length > 60) {
        $('#wk-password').addClass('border-error');
        $('#wk-password-error').text(password_length);
        $('.error_wk_password').show();
        return false;
    } else {
        $('#wk-password').removeClass('border-error').addClass('border-success');
        $('.error_wk_password').hide();
        $('.icon_wk_password').show();
        $('#wk-password-error').hide();
        return true;
    }
}

function checkEmailExist(email, create_account) {
    Window.error = false;
    $.ajax({
        type: 'POST',
        url: wkcheckout,
        // async: false,
        dataType: 'json',
        data: {
            'ajax': true,
            'email': email,
            'create_account': create_account,
            'action': 'checkEmail',
            'token': wktoken,
        },
        beforeSend: function() {
            showCustomerLoader();
        },
        complete: function() {
            hideCustomerLoader();
        },
        success: function(result) {
            if (result.status == 'ko') {
                $('#' + result.id).removeClass('border-success').addClass('border-error');
                $('#wk-email-error').html(result.msg);
                $('.icon_wk_email').hide();
                $('.error_wk_email').show();
                Window.error = true;
            } else {
                $('#wk-email').removeClass('border-error').addClass('border-success');
                $('.error_wk_email').hide();
                $('.icon_wk_email').show();
            }
        },
    });

    if (Window.error) {
        return false;
    }

    return true;
}

function validateCustomerAddress() {
    var selectedDeliveryAddress = $('input[name=wk-delivery-address]:checked').val();
    var selectedInvoiceAddress = $('input[name=wk-invoice-address]:checked').val();

    // checking delivery address
    if (typeof selectedDeliveryAddress === 'undefined') {
        var formData = $('#wk-delivery-form').serialize();
        var isDeliveryAddressValidated = validateDeliveryFormData(formData, 'delivery');
        if (!isDeliveryAddressValidated) {
            return false;
        }
    } else {
        if (selectedDeliveryAddress == 1) {
            var idDeliveryAddress = $('#wk-existing-delivery-address').val();
            if (typeof idDeliveryAddress === 'undefined') {
                wkShowError(delivery_adrs_not_select);
                return false;
            }
        } else if (selectedDeliveryAddress == 2) {
            var idDeliveryAddress = $('#id-new-delivery-address').val();
            if (typeof idDeliveryAddress === 'undefined') {
                var formData = $('#wk-delivery-form').serialize();
                var isDeliveryAddressValidated = validateDeliveryFormData(formData, 'delivery');
                if (!isDeliveryAddressValidated) {
                    return false;
                }
            }
        }
    }

    // checking invoice address
    if ($('input[name="wk-different-invoice"]').is(":checked")) {
        return true;
    } else {
        if (typeof selectedInvoiceAddress === 'undefined') {
            var formData = $('#wk-invoice-form').serialize();
            var isInvoiceAddressCreated = validateDeliveryFormData(formData, 'invoice');
            if (!isInvoiceAddressCreated) {
                return false;
            }
        } else {
            if (selectedInvoiceAddress == 1) {
                var idInvoiceAddress = $('#wk-existing-invoice-address').val();
                if (typeof idInvoiceAddress === 'undefined') {
                    wkShowError(invoice_not_created);
                    return false;
                }
            } else if (selectedInvoiceAddress == 2) {
                var idInvoiceAddress = $('#id-new-invoice-address').val();
                if (!idInvoiceAddress) {
                    var formData = $('#wk-invoice-form').serialize();
                    var isInvoiceAddressCreated = validateDeliveryFormData(formData, 'invoice');
                    if (!isInvoiceAddressCreated) {
                        return false;
                    }
                }
            }
        }
    }

    return true;
}

function validateDeliveryDateAndTime() {
    if($('#ddw_calendar').hasClass('hasDatepicker')){
        var calendar = $("#ddw_calendar");
        var timeslots = $("#ddw_timeslots");
        if (calendar) {
            var ddw_order_date = $("#ddw_order_date").val();
            if (ddw_order_date == '') {
                $.growl.error({ title: "", message: delivery_date_error});
                return false;
            } else {
                if(timeslots) {
                    var ddw_order_time_div = $("#ddw-timeslots");
                    if (typeof ddw_order_time_div != "undefined") {
                        var ddw_order_time = $("#ddw_order_time").val();
                        if (ddw_order_time == '') {
                            $.growl.error({ title: "", message: delivery_time_error});
                            return false;
                        } else {
                            return true;
                        }
                    }
                }
            }
        }
    } else {
        return true;
    }
}

function validateOrderSummary() {
    Window.error = false;
    $.ajax({
        type: 'POST',
        url: wkcheckout,
        // cache: false,
        // async: false,
        dataType: 'json',
        data: {
            'ajax': true,
            'action': 'checkProductQuantity',
            'token': wktoken,
        },
        beforeSend: function() {
            showOrderSummaryLoader();
        },
        complete: function() {
            hideOrderSummaryLoader();
        },
        success: function(result) {
            if (!jQuery.isEmptyObject(result)) {
                $.each(result, function(i, item) {
                    if (item.status == 'ko') {
                        //$('.wkorder_error').show().append('<p>' + item.msg + '</p>');
                        $('.wkorder_error .wk-qty-error').remove();
                        $('.wkorder_error').show().append('<div class="col-md-12 alert alert-danger wk-qty-error">' + item.msg + '</div>');
                    }
                });
                Window.error = true;
            }
        },
        error: function() {},
    });
    if (Window.error) {
        return false;
    }
    return true;
}

// Create a function remove comma from shipping value
function removeCommaFromShipping(shippingMethod) {
    if (shippingMethod) {
        return shippingMethod.replace(/\,/g,"");
    }
    return;
}

function validateShippingSelection() {
    // checking shipping method
    var shippingMethodWithComma = $('input:radio.wk_selected_shipping:checked').val();
    var shippingMethod = removeCommaFromShipping(shippingMethodWithComma);
    if (typeof shippingMethod === 'undefined' && !wkvirtualcart) {
        wkShowError(no_shipping_select);
        return false;
    }

    return true;
}

function validatePaymentSelection() {
    // checking payment method
    var paymentMethod = $('input[name=payment-option]:checked').val();
    if (typeof paymentMethod === 'undefined') {
        /* Adriana - 15/07/2020 - in??cio */
        $('#wkpayment-error').show().text(wk_payment_err);
        $('html, body').animate({
            scrollTop: ($('.wk-payment-icon').offset().top - 10)
        }, 2000);
        $.growl.error({ title: "", message: no_payment_select});
        /* Adriana - 15/07/2020 - fim */
        return false;
    }
    if ($('input[name=payment-option]:checked').parents('.wk-payment-select').is('#eredepro5')) {
        var paymentMethod = $('input[name=payment-option]:checked').val();
        var payOption = $(".payment-option .custom-radio input:radio:checked").attr('id');
        if (typeof paymentMethod != 'undefined' && payOption == 'payment-option-2') {
            // $("#pay-with-payment-option-2-form").find('div.form-group input').blur();
            if ($("#pay-with-payment-option-2-form").find('div.form-group').hasClass('has-error')) {
                $('html, body').animate({
                    scrollTop: ($("#payment-option-2").offset().top - 10)
                }, 2000);
                $.growl.error({ title: "", message: fill_payment_error});
                return false;
            }
        } else if (typeof paymentMethod != 'undefined' &&  payOption ==  'payment-option-3') {
            // $("#pay-with-payment-option-3-form").find('div.form-group input').blur();
            if ($("#pay-with-payment-option-3-form").find('div.form-group').hasClass('has-error')) {
                $('html, body').animate({
                    scrollTop: ($("#payment-option-3").offset().top - 10)
                }, 2000);
                $.growl.error({ title: "", message: fill_payment_error});
                return false;
            }
        }
    }
    return true;
}

function makePayment() {
    // adding prestashop payment button
    $('.wk_ps_payment_button').html('<div id="payment-confirmation"><div class="ps-shown-by-js"><button type="submit" class="btn btn-primary center-block"></button></div></div>');

    // triggering click for prestashop payment button in order to proceed payment using prestashop method
    var paymentModule = $('input[name=payment-option]:checked').attr('data-module-name');
    if (paymentModule == 'stripepayment' || paymentModule == 'wkstripepayment') {
        user_email = $('#wk-email').val();
        /* Adriana - 08/04/2021 - in??cio */
        user_email = user_email.trim();
        /* Adriana - 08/04/2021 - fim */
        openStripeCheckout();
        $('.wk_ps_stripe').trigger('click');
    } else {
        $('#payment-confirmation button').trigger('click');
    }
}

function createAccount() {
    var fname = $('#wk_delivery_first_name').val();
    var lname = $('#wk_delivery_last_name').val();
    var email = $('#wk-email').val();
    /* Adriana - 08/04/2021 - in??cio */
    email = email.trim();
    /* Adriana - 08/04/2021 - fim */

    if (wk_guest_allow == 1) {
        if ($('#wk-create-account').is(":checked")) {
            var create_account = 1;
            var pswrd = $('#wk-password').val();
        } else {
            var create_account = 0;
        }
    } else {
        var create_account = 1;
        var pswrd = $('#wk-password').val();
    }
    var social_title = $('input[name=id_gender]:checked').val();
    if (typeof social_title === 'undefined') {
        social_title = 0;
    }
    var wk_optin = $('input[name=wk-optin]:checked').val();
    if (typeof wk_optin === 'undefined') {
        wk_optin = 0;
    }
    var wk_newsletter = $('input[name=wk-newsletter]:checked').val();
    if (typeof wk_newsletter === 'undefined') {
        wk_newsletter = 0;
    }
    var wk_day = $('select[name=wk_day]').val();
    if (typeof wk_day === 'undefined') {
        wk_day = 0;
    }
    var wk_month = $('select[name=wk_month]').val();
    if (typeof wk_month === 'undefined') {
        wk_month = 0;
    }
    var wk_year = $('select[name=wk_year]').val();
    if (typeof wk_year === 'undefined') {
        wk_year = 0;
    }

    Window.idCustomer = false;
    $.ajax({
        type: 'POST',
        url: wkcheckout,
        async: false,
        data: {
            'ajax': true,
            'fname': fname,
            'lname': lname,
            'email': email,
            'password': pswrd,
            'social_title': social_title,
            'wk_optin': wk_optin,
            'wk_newsletter': wk_newsletter,
            'wk_day': wk_day,
            'wk_month': wk_month,
            'wk_year': wk_year,
            'action': 'createAccount',
            'create_account': create_account,
            'token': wktoken,
        },
        beforeSend: function() {
            showCustomerLoader();
        },
        complete: function() {
            hideCustomerLoader();
        },
        success: function(result) {
            if (result) {
                Window.idCustomer = result;
            }
        },
        error: function() {},
    });

    if (Window.idCustomer) {
        return Window.idCustomer;
    }

    return Window.idCustomer;
}

function createCustomerAddress(wknewtoken) {
    var selectedDeliveryAddress = $('input[name=wk-delivery-address]:checked').val();
    var selectedInvoiceAddress = $('input[name=wk-invoice-address]:checked').val();
    // checking delivery address
    if (typeof selectedDeliveryAddress === 'undefined') {
        var formData = $('#wk-delivery-form').serialize();
        isDeliveryAddressCreated = createNewAddress(formData, 'delivery', false, false, wknewtoken);
        if (!isDeliveryAddressCreated) {
            wkShowError(delivery_not_created);
            return false;
        }
    } else {
        if (selectedDeliveryAddress == 1) {
            var idDeliveryAddress = $('#wk-existing-delivery-address').val();
            if (typeof idDeliveryAddress === 'undefined') {
                wkShowError(delivery_adrs_not_select);
                return false;
            }
        } else if (selectedDeliveryAddress == 2) {
            var idDeliveryAddress = $('#id-new-delivery-address').val();
            if (typeof idDeliveryAddress === 'undefined') {
                var formData = $('#wk-delivery-form').serialize();
                isDeliveryAddressCreated = createNewAddress(formData, 'delivery', false, false, wknewtoken);
                if (!isDeliveryAddressCreated) {
                    wkShowError(delivery_not_created);
                    return false;
                }
            }
        }
    }

    // checking invoice address
    if ($('input[name="wk-different-invoice"]').is(":checked")) {
        if (typeof selectedDeliveryAddress === 'undefined') {
            var idInvoiceAddress = $('#id-new-delivery-address').val();
            if (typeof idInvoiceAddress === 'undefined') {
                wkShowError(invoice_adrs_not_select);
                return false;
            }
        } else {
            if (selectedDeliveryAddress == 1) {
                var idInvoiceAddress = idDeliveryAddress;
            } else {
                var idInvoiceAddress = $('#id-new-delivery-address').val();
            }

            if (!idInvoiceAddress) {
                wkShowError(invoice_adrs_not_select);
                return false;
            }
        }
    } else {
        if (typeof selectedInvoiceAddress === 'undefined') {
            var formData = $('#wk-invoice-form').serialize();
            isInvoiceAddressCreated = createNewAddress(formData, 'invoice', false, false, wknewtoken);
            if (!isInvoiceAddressCreated) {
                wkShowError(invoice_not_created);
                return false;
            }
        } else {
            if (selectedInvoiceAddress == 1) {
                var idInvoiceAddress = $('#wk-existing-invoice-address').val();
                if (typeof idInvoiceAddress === 'undefined') {
                    wkShowError(invoice_adrs_not_select);
                    return false;
                }
            } else if (selectedInvoiceAddress == 2) {
                var idInvoiceAddress = $('#id-new-invoice-address').val();
                if (!idInvoiceAddress) {
                    var formData = $('#wk-invoice-form').serialize();
                    isInvoiceAddressCreated = createNewAddress(formData, 'invoice', false, false, wknewtoken);
                    if (!isInvoiceAddressCreated) {
                        wkShowError(invoice_not_created);
                        return false;
                    }
                }
            }
        }
    }

    return true;
}

function validatePostalCode(fieldValue, fieldId, idCountry) {
    $.ajax({
        type: 'POST',
        url: wkcheckout,
        async: false,
        dataType: 'json',
        data: {
            'ajax': true,
            'fieldValue': fieldValue,
            'fieldId': fieldId,
            'idCountry': idCountry,
            'action': 'checkPostalCode',
            'token': wktoken,
        },
        beforeSend: function() {
            showCustomerLoader();
        },
        complete: function() {
            hideCustomerLoader();
        },
        success: function(result) {
            if (result.status == 'ko') {
                $('#' + fieldId).addClass('border-error').removeClass('border-success');
                $('.' + fieldId).html(result.msg);
                $('.icon_' + fieldId).addClass('wkhide').removeClass('wkshow');
                $('.error_' + fieldId).addClass('wkshow').removeClass('wkhide');
            } else {
                $('.' + fieldId).text('');
                $('#' + fieldId).removeClass('border-error').addClass('border-success');
                $('.icon_' + fieldId).addClass('wkshow').removeClass('wkhide');
                $('.error_' + fieldId).addClass('wkhide').removeClass('wkshow');
            }
        },
        error: function() {},
    });
}

function validateDeliveryFormData(formData, dataType) {
    error = false;
    $.ajax({
        type: 'POST',
        url: wkcheckout,
        async: false,
        dataType: 'json',
        data: {
            'ajax': true,
            'formData': formData,
            'dataType': dataType,
            'action': 'validateDeliveryFormField',
            'token': wktoken,
        },
        beforeSend: function() {
            showCustomerLoader();
        },
        complete: function() {
            hideCustomerLoader();
        },
        success: function(result) {
            if (result) {
                $.each(result, function(i, item) {
                    if (item.status == 'ko') {
                        $('#' + item.id).addClass('border-error').removeClass('border-success');
                        $('.' + item.id).html(item.msg);
                        $('.icon_' + item.id).addClass('wkhide').removeClass('wkshow');
                        $('.error_' + item.id).addClass('wkshow').removeClass('wkhide');
                        error = true;
                        /* Adriana - 15/07/2020 - in??cio */
                        /*
                        $("a[href='#wk-existing-" + dataType + "']").trigger('click');
                        */
                    } else if (item.status == 'ok') {
                        $('#' + item.id).addClass('border-success').removeClass('border-error');
                        $('.' + item.id).html("");
                        $('.icon_' + item.id).addClass('wkshow').removeClass('wkhide');
                        $('.error_' + item.id).addClass('wkhide').removeClass('wkshow');
                    }
                        /* Adriana - 15/07/2020 - fim */
                });
            }
        },
    });

    if (error) {
        return false;
    }

    return true;   
}

function createNewAddress(formData, dataType, updateShipping, updatePayment, wknewtoken) {
    if (typeof wknewtoken !== 'undefined') {
        if (wknewtoken) {
            wktoken = wknewtoken;
        }
    }
    Window.error = false;
    $.ajax({
        type: 'POST',
        url: wkcheckout,
        async: false,
        data: {
            'ajax': true,
            'formData': formData,
            'dataType': dataType,
            'action': 'createAddress',
            'token': wktoken,
        },
        beforeSend: function() {
            showCustomerLoader();
        },
        complete: function() {
            hideCustomerLoader();
        },
        success: function(result) {
            if (result) {
                if (dataType == 'delivery') {
                    $('#wk-delivery-address-form').html(result);
                    var idDeliveryAddress = $('#id-new-delivery-address').val();
                    if (typeof idDeliveryAddress === 'undefined') {
                        Window.error = true;
                    } else {
                        if ($('input[name="wk-different-invoice"]').is(":checked")) {
                            var idInvoiceAddress = idDeliveryAddress;
                        } else {
                            var idInvoiceAddress = $('#wk-existing-invoice-address').val();
                        }
                        updateCustomerAddress(
                            idDeliveryAddress,
                            idInvoiceAddress,
                            dataType,
                            updateShipping,
                            updatePayment
                        );
                    }
                } else {
                    $('#wk-invoice-address-form').html(result);
                    var idInvoiceAddress = $('#id-new-invoice-address').val();
                    if (typeof idInvoiceAddress === 'undefined') {
                        Window.error = true;
                    } else {
                        if ($('input[name="wk-delivery-address"]:checked').val() == 1) {
                            var idDeliveryAddress = $('#wk-existing-delivery-address option:selected').val();
                        } else {
                            var idDeliveryAddress = $('#id-new-delivery-address').val();
                        }
                        updateCustomerAddress(
                            idDeliveryAddress,
                            idInvoiceAddress,
                            dataType,
                            updateShipping,
                            updatePayment
                        );
                    }
                }
            } else {
                Window.error = true;
            }
        },
        error: function() {},
    });

    if (Window.error) {
        return false;
    }

    return true;
}

function validateAddressField(fieldValue, fieldId, fieldValidation, maxlength, required) {
    $.ajax({
        type: 'POST',
        url: wkcheckout,
        async: true,
        dataType: 'json',
        data: {
            'ajax': true,
            'fieldValue': fieldValue,
            'fieldId': fieldId,
            'fieldValidation': fieldValidation,
            'maxlength': maxlength,
            'required': required,
            'action': 'validateAddressField',
            'token': wktoken,
        },
        beforeSend: function() {
            showCustomerLoader();
        },
        complete: function() {
            hideCustomerLoader();
        },
        success: function(result) {
            if (result.status == 'ko') {
                $('#' + fieldId).addClass('border-error').removeClass('border-success');
                $('.' + fieldId).text(result.msg);
                $('.icon_' + fieldId).addClass('wkhide').removeClass('wkshow');
                $('.error_' + fieldId).addClass('wkshow').removeClass('wkhide');
            } else {
                $('.' + fieldId).text('');
                $('#' + fieldId).removeClass('border-error').addClass('border-success');
                $('.icon_' + fieldId).addClass('wkshow').removeClass('wkhide');
                $('.error_' + fieldId).addClass('wkhide').removeClass('wkshow');
            }
        },
        error: function() {},
    });
}

function updateCustomerAddress(idAddress, idAddressInvoice, address, updateShipping, updatePayment) {
    $.ajax({
        type: 'POST',
        url: wkcheckout,
        cache: false,
        async: false,
        data: {
            'ajax': true,
            'action': 'changeAddressCard',
            'address': address,
            'idAddress': idAddress,
            'idAddressInvoice': idAddressInvoice,
            'token': wktoken,
        },
        beforeSend: function() {
            showCustomerLoader();
        },
        complete: function() {
            window.location.reload(true);
            hideCustomerLoader();
        },
        success: function(result) {
            if (address == 'delivery') {
                $('.wk-delivery-address-card').html(result);
            } else if (address == 'invoice') {
                $('.wk-invoice-address-card').html(result);
            }
            $('#wkcustomer_info').html('');
            updateOrderSummary();
            if (updateShipping) {
                updateShippingMethod(0, 0, 0);
            } else {
                showShippingMethodLoader();
            }
            if (updatePayment) {
                updatePaymentMethod(1, false, false);
            } else {
                showPaymentMethodLoader();
            }
        },
        error: function() {},
    });
}

function setDeliveryMethod(idCarrier, idCountry, paymentupdate, wknewtoken) {
    if (typeof wknewtoken !== 'undefined') {
        if (wknewtoken) {
            wktoken = wknewtoken;
        }
    }
    $.ajax({
        type: 'POST',
        url: wkcheckout,
        async: false,
        data: {
            'ajax': true,
            'idCarrier': idCarrier,
            'action': 'setDeliveryOption',
            'token': wktoken,
        },
        beforeSend: function() {
            showShippingMethodLoader();
        },
        complete: function() {
            hideShippingMethodLoader();
        },
        success: function(result) {
            if (idCountry) {
                updateOrderSummary().then(function(ordersummaryresponse){
                    if (ordersummaryresponse) {
                        updatePaymentMethod(0, idCountry, idCarrier);
                    }
                });
            } else {
                if (paymentupdate) {
                    updateOrderSummary().then(function(ordersummaryresponse){
                        if (ordersummaryresponse) {
                            updatePaymentMethod(1, idCountry, false);
                        }
                    });
                }
            }
        },
        error: function() {},
    });
    return true;
}

function addVoucherOnCart(discountName) {
    $.ajax({
        type: 'POST',
        url: wkcheckout,
        // cache: false,
        // async: false,
        dataType: 'json',
        data: {
            'ajax': true,
            'action': 'addVoucher',
            'discountName': discountName,
            'token': wktoken,
        },
        beforeSend: function() {
            showOrderSummaryLoader();
        },
        complete: function() {
            hideOrderSummaryLoader();
        },
        success: function(result) {
            if (result.status == 'ok') {
                updateOrderSummary().then(function(ordersummaryresponse){
                    if (ordersummaryresponse) {
                        updateShippingorPayment();
                    }
                });
            } else {
                $('.wkpromo-code').removeClass('wkhide').addClass('wkshow');
                $('.wkpromo-code span').text(result.msg);
            }
        },
    });
}

function deleteCartVoucher(idVoucher) {
    var deletecartvoucher = $.ajax({
        type: 'POST',
        url: wkcheckout,
        //cache: false, //only work correctly with HEAD and GET requests.
        //async: false,
        dataType: 'json',
        data: {
            'ajax': true,
            'action': 'deleteVoucher',
            'deleteDiscount': idVoucher,
            'token': wktoken,
        },
    });

    var deletecartvouchersuccess = function(result) {
        if (result.status == 'ok') {
            updateOrderSummary().then(function(ordersummaryresponse){
                if (ordersummaryresponse) {
                    updateShippingorPayment();
                }
            });
        }
    }

    //@TODO::to set error

    deletecartvoucher.then(deletecartvouchersuccess);
}

function getStateByIdCountry(idCountry, dataAttr) {
    $.ajax({
        type: 'POST',
        url: wkcheckout,
        // cache: false,
        // async: false,
        data: {
            'ajax': true,
            'action': 'getState',
            'idCountry': idCountry,
            'dataAttr': dataAttr,
            'token': wktoken,
        },
        beforeSend: function() {
            showCustomerLoader();
        },
        complete: function() {
            hideCustomerLoader();
        },
        success: function(result) {
            if (dataAttr == 'delivery') {
                updateShippingMethod(1, idCountry, 0).then(function(updateshippingresponse){
                    if (updateshippingresponse) {
                        updatePaymentMethod(0, idCountry, 0);
                    }
                });
                if (result) {
                    $('#wk_delivery_address_state').html(result);
                } else {
                    $('#wk_delivery_address_state').html('');
                }
            } else if (dataAttr == 'invoice') {
                if (result) {
                    $('#wk_invoice_address_state').html(result);
                } else {
                    $('#wk_invoice_address_state').html('');
                }
            }
        },
        error: function() {},
    });
}

function saveCart(obj, action, condition, currentQty) {
    Window.success = false;
    if (action == 'saveCartProduct') {
        var idProduct = obj.attr('data-id-product');
        var idProductAttribute = obj.attr('data-id-product-attribute');
        currentQty = obj.attr('data-quantity');
    }

    var saveCartAjax = $.ajax({
        type: 'POST',
        url: wkcheckout,
        cache: false,
        async: false,
        data: {
            'ajax': true,
            'action': action,
            'qty': currentQty,
            'operator': condition,
            'idProduct': idProduct,
            'idProductAttribute': idProductAttribute,
            'token': wktoken,
        },
        beforeSend: function() {
            showOrderSummaryLoader();
        },
        complete: function() {
            hideOrderSummaryLoader();
            wkShowSuccess(saveSuccessMsg);
        },
    });

    var saveCartSuccess = function(result) {
        if (result) {
            Window.success = true;
        }
    };

    saveCartAjax.then(saveCartSuccess);
    return saveCartAjax;
    // if (Window.success) {
    //     return true;
    // }
    //
    // return false;
}

function changeCartQuantity(obj, action, condition, currentQty, changebyinput) {
    var changeQty = 0;
    var idProduct = obj.parent().siblings('input.wk-qty').attr('data-id-product');
    var idProductAttribute = obj.parent().siblings('input.wk-qty').attr('data-id-product-attribute');
    var idCustomization = obj.parent().siblings('input.wk-qty').attr('data-id-customization');

    if (action == 'deleteCartProduct') {
        var idProduct = obj.attr('data-id-product');
        var idProductAttribute = obj.attr('data-id-product-attribute');
        var idCustomization = obj.attr('data-id-customization');
    }

    if (changebyinput) {
        changeQty = 1;
        var idProduct = obj.attr('data-id-product');
        var idProductAttribute = obj.attr('data-id-product-attribute');
        var idCustomization = obj.attr('data-id-customization');
    }

    $.ajax({
        type: 'POST',
        url: wkcheckout,
        // cache: false,
        // async: false,
        data: {
            'ajax': true,
            'action': action,
            'qty': currentQty,
            'changeQty': changeQty,
            'operator': condition,
            'idProduct': idProduct,
            'idProductAttribute': idProductAttribute,
            'idCustomization': idCustomization,
            'token': wktoken,
        },
        beforeSend: function() {
            showOrderSummaryLoader();
        },
        complete: function() {
            window.location.reload(true);
            hideOrderSummaryLoader();
        },
        success: function(result) {

            if (result == '0') {
                $('.wkorder_error').show().text(wk_no_longer);
            } else if (result == '2') {
                $('.wkorder_error').show().text(wk_no_stock);
            } else if (result == '3') {
                $('.wkorder_error').show().text(wk_minimum_qty);
            } else if (result == '4') {
                $('.wkorder_error').show().text(wk_max_qty);
            } else if (result == '5') {
                $('.wkorder_error').show().text(wk_update_qty_err);
            } else if (result == 6) {
                window.location.reload(true);
            } else if (result == 7) {
                // Nothing happend as no quantity change
            } else if (result) {
                $('.wkorder_error').hide().text('');
                updateOrderSummary().then(function(ordersummaryresponse){
                    if (ordersummaryresponse) {
                        updateShippingorPayment();
                    }
                });
                updateFooterBlock();
                wkShowSuccess(deleteSuccessMsg);
            } else {
                window.location.reload(true);
            }
        },
    });
}

function addProductIntoCart(idProduct, idProductAttribute) {
    $.ajax({
        type: 'POST',
        url: wkcart,
        cache: false,
        async: false,
        data: {
            'ajax': true,
            'action': 'update',
            'token': wktoken,
            'add': 1,
            'qty': 1,
            'id_product': idProduct,
            'id_customization': 0,
        },
        beforeSend: function() {
            //showOrderSummaryLoader();
        },
        complete: function() {
            //hideOrderSummaryLoader();
        },
        success: function(result) {
            if (result) {
                $('html, body').animate({
                    scrollTop: ($('#wk-one-page-checkout').offset().top)
                }, 2000, function() {
                    updateOrderSummary().then(function(ordersummaryresponse){
                        if (ordersummaryresponse) {
                            updateShippingorPayment();
                        }
                    });
                    updateFooterBlock();
                });
            } else {
                window.location.reload(true);
            }
        },
        error: function() {},
    });
}

function updateFooterBlock() {
    $.ajax({
        type: 'POST',
        url: wkcheckout,
        cache: false,
        async: false,
        data: {
            'ajax': true,
            'action': 'updateFooter',
            'token': wktoken,
        },
        beforeSend: function() {

        },
        complete: function() {

        },
        success: function(result) {
            if (result) {
                $('.wk-products').html(result);
            } else {
                $('#wk-products').remove();
            }
        }
    });
}

function loginSubmit(action, info, condition) {
    $.ajax({
        type: 'POST',
        url: wkcheckout,
        // cache: false,
        // async: false,
        dataType: 'json',
        data: {
            ajax: true,
            action: action,
            params: info,
            'token': wktoken,
        },
        beforeSend: function() {
            if (condition == 'login') {
                $('.wk-loader').removeClass('wkhide').addClass('wkshowinline');
                $('#wk-submit-login').attr('disabled', 'disabled');
            }
        },
        complete: function() {
            if (condition == 'login') {
                $('.wk-loader').removeClass('wkshowinline').addClass('wkhide');
                $('#wk-submit-login').removeAttr('disabled');
            }
        },
        success: function(result) {
            if (result.status == 'ok') {
                window.location.reload(true);
            } else {
                $('.wk-login-error').text(result.msg).removeClass('wkhide').addClass('wkshow');
                $('#' + result.id).addClass('border-error');
            }
        },
        error: function() {},
    });
}

function changeLogin(val) {
    if (val == 1) { // Already Login Customers
        $('.wk-login-form').removeClass('wkhide').addClass('wkshow');
        $('.wk-guest-registration, .wk-delivery-address-form').removeClass('wkshow').addClass('wkhide');
    } else if (val == 2) { // Guest Customers
        $('.wk-login-form').removeClass('wkshow').addClass('wkhide');
        $('.wk-guest-registration, .wk-delivery-address-form').removeClass('wkhide').addClass('wkshow');
        $('#wk-registration-password').removeClass('wkshow').addClass('wkhide');
    } else if (val == 3) { // New Account Creation
        $('.wk-login-form').removeClass('wkshow').addClass('wkhide');
        $('.wk-guest-registration, .wk-delivery-address-form').removeClass('wkhide').addClass('wkshow');
        $('#wk-registration-password').removeClass('wkhide').addClass('wkshow');
    }
}

function showNewDeliveryAddress(condition) {
    if (condition == 1) {
        $('#wk-new-delivery').removeClass('wkshow').addClass('wkhide');
        $('#wk-existing-delivery-address').removeAttr('disabled');
        $('.wk-delivery-address-div').slideDown();

        var idAddress = $('#wk-existing-delivery-address option:selected').val();
        if ($('input[name="wk-different-invoice"]').is(":checked")) {
            var idAddressInvoice = idAddress;
        } else {
            var idAddressInvoice = $('#wk-existing-invoice-address option:selected').val();
        }
        updateCustomerAddress(idAddress, idAddressInvoice, 'delivery', true, true);
    } else if (condition == 2) {
        $('#wk-new-delivery').removeClass('wkhide').addClass('wkshow');
        $('#wk-existing-delivery-address').attr('disabled', 'disabled');
        $('.wk-delivery-address-div').slideUp();

        var idCountry = $('.wk_address_country option:selected').val();
        getStateByIdCountry(idCountry, 'delivery');
    }
}

function showInvoiceAddress(condition) {
    if (condition == 1) {
        $('#wk-new-invoice').removeClass('wkshow').addClass('wkhide');
        $('#wk-existing-invoice-address').removeAttr('disabled');
    } else if (condition == 2) {
        $('#wk-new-invoice').removeClass('wkhide').addClass('wkshow');
        $('#wk-existing-invoice-address').attr('disabled', 'disabled');
    }
}

function updateOrderSummary() {
    var ordersummary = $.ajax({
        type: 'POST',
        url: wkcheckout,
        // cache: false,
        // async: false,
        data: {
            'ajax': true,
            'action': 'updateOrderSummary',
            'token': wktoken,
        },
        beforeSend: function() {
            showOrderSummaryLoader();
        },
        complete: function() {
            hideOrderSummaryLoader();
        },
    });

    var ordersummarysuccess = function(result) {
        if (parseInt(result) == 6) {
            showOrderSummaryLoader();
            window.location.href = wkhome;
            return;
        } else {
            $('#wk-order-summary-ajax').html(result);
        }
    };
    ordersummary.then(ordersummarysuccess);

    return ordersummary;
}

function updateShippingMethod(newAddress, idCountry, idState) {
    var updateshippingajax = $.ajax({
        type: 'POST',
        url: wkcheckout,
        // async: false,
        // cache: false,
        data: {
            'ajax': true,
            'action': 'updateShipping',
            'newAddress': newAddress,
            'idCountry': idCountry,
            'idState': idState,
            'token': wktoken,
            'wk_is_logged': wk_is_logged
        },
        beforeSend: function() {
            showShippingMethodLoader();
        },
        complete: function() {
            hideShippingMethodLoader();
        },
    });

    var updateshippingsuccess = function(result) {
        if (wkvirtualcart) {
            $('.wk-shipping-carriers').html('');
        } else {
            $('.wk-shipping-carriers').html(result);
        }
    };

    updateshippingajax.then(updateshippingsuccess);
    return updateshippingajax;
}

function updatePaymentMethod(showPayment, idCountry, idCarrier) {
    $.ajax({
        type: 'POST',
        url: wkcheckout,
        // async: false,
        // cache: false,
        data: {
            'ajax': true,
            'action': 'updatePaymentMethod',
            'showPayment': showPayment,
            'idCountry': idCountry,
            'idCarrier': idCarrier,
            'token': wktoken,
            'wk_is_logged': wk_is_logged
        },
        beforeSend: function() {
            showPaymentMethodLoader();
        },
        complete: function() {
            hidePaymentMethodLoader();
        },
        success: function(result) {
            $('.wk-payment-method').html(result);
        },
        error: function() {},
    });
}

function showCustomerLoader() {
    $('#wkcustomer_info').html('<div class="wkloading_overlay"><div class="spinner"> <div class="bounce1"></div> <div class="bounce2"></div> <div class="bounce3"></div></div>');
}

function hideCustomerLoader() {
    $('#wkcustomer_info').html('');
}

function showOrderSummaryLoader() {
    $('#wkorder-summary').html('<div class="wkloading_overlay"><div class="spinner"> <div class="bounce1"></div> <div class="bounce2"></div> <div class="bounce3"></div></div>');
}

function hideOrderSummaryLoader() {
    $('#wkorder-summary').html('');
}

function showShippingMethodLoader() {
    $('#wkshipping-method').html('<div class="wkloading_overlay"><div class="spinner"> <div class="bounce1"></div> <div class="bounce2"></div> <div class="bounce3"></div></div>');
}

function hideShippingMethodLoader() {
    $('#wkshipping-method').html('');
}

function showPaymentMethodLoader() {
    $('#wkpayment-method').html('<div class="wkloading_overlay"><div class="spinner"> <div class="bounce1"></div> <div class="bounce2"></div> <div class="bounce3"></div></div>');
}

function hidePaymentMethodLoader() {
    $('#wkpayment-method').html('');
}

function showTermsNConditionLoader() {
    $('#wkcondition_info').html('<div class="wkloading_overlay"><div class="spinner" style="top:-115%;"> <div class="bounce1"></div> <div class="bounce2"></div> <div class="bounce3"></div></div>');
}

function hideTermsNConditionLoader() {
    $('#wkcondition_info').html('');
}

function updateShippingorPayment() {
    if (wk_is_logged == 0) {
        var idCountry = $('select[name=wk_delivery_address_country] option:selected').val();
        if (typeof idCountry !== 'undefined') {
            updateShippingMethod(1, idCountry, 0).then(function(updateshippingresponse){
                if (updateshippingresponse) {
                    updatePaymentMethod(0, idCountry, false);
                }
            });
        } else {
            updateShippingMethod(0, false, 0).then(function(updateshippingresponse){
                if (updateshippingresponse) {
                    updatePaymentMethod(1, false, false);
                }
            });
        }
    } else {
        updateShippingMethod(0, false, 0).then(function(updateshippingresponse){
            if (updateshippingresponse) {
                updatePaymentMethod(1, false, false);
            }
        });
    }
}

function ValidateEmail(email) {
    var check = /^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
    return check.test(email);
};
