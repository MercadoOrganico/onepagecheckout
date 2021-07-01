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

function addRemoteAddr() {
    var ip = $('#wk_ip_address').val();
    var length = $('input[name=wk_checkout_ip_address]').attr('value').length;
    if (length > 0) {
        if ($('input[name=wk_checkout_ip_address]').attr('value').indexOf(ip) < 0) {
            $('input[name=wk_checkout_ip_address]').attr('value', ip);
        }
    } else {
        $('input[name=wk_checkout_ip_address]').attr('value', ip);
    }
}

// ----- On clicking checkout mode ----------------------------------
$(document).on('change', 'input[name=wk_checkout_mode]', function() {
    if ($(this).val() == '1') {
        $('.wk-general-setting').show('slow');
    } else {
        $('.wk-general-setting').hide('slow');
    }
});

$(document).ready(function() {
    if ($('input[name=wk_checkout_mode]:checked').val() == '1') {
        $('.wk-general-setting').show('slow');
    } else {
        $('.wk-general-setting').hide();
    }
});
// ----- End of code ----------------------------------

// ----- On clicking sanbox ----------------------------------
$(document).on('change', 'input[name=wk_checkout_sandbox]', function() {
    if ($(this).val() == '1') {
        $('.wk-checkout-ips').show('slow');
    } else {
        $('.wk-checkout-ips').hide('slow');
    }
});

$(document).ready(function() {
    if ($('input[name=wk_checkout_sandbox]:checked').val() == '1') {
        $('.wk-checkout-ips').show('slow');
    } else {
        $('.wk-checkout-ips').hide();
    }
});
// ----- End of code ----------------------------------

// ------------ On clicking social login ---------------------
$(document).on('change', 'input[name=wk_checkout_social_login]', function() {
    if ($(this).val() == '1') {
        $('.wk-social-login-tabs').show('slow');
    } else {
        $('.wk-social-login-tabs').hide('slow');
    }
});

$(document).ready(function() {
    if ($('input[name=wk_checkout_social_login]:checked').val() == '1') {
        $('.wk-social-login-tabs').show('slow');
    } else {
        $('.wk-social-login-tabs').hide();
    }
});
// ----- End of code ----------------------------------

// ------------ On clicking facebook ---------------------
$(document).on('change', 'input[name=wk_checkout_facebook_login]', function() {
    if ($(this).val() == '1') {
        $('.wk_checkout_fb_config').show('slow');
    } else {
        $('.wk_checkout_fb_config').hide('slow');
    }
});

$(document).ready(function() {
    if ($('input[name=wk_checkout_facebook_login]:checked').val() == '1') {
        $('.wk_checkout_fb_config').show('slow');
    } else {
        $('.wk_checkout_fb_config').hide('slow');
    }
});
// ----- End of code ----------------------------------


// ------------ On clicking Google login ---------------------
$(document).on('change', 'input[name=wk_checkout_google_login]', function() {
    if ($(this).val() == '1') {
        $('.wk_checkout_google_config').show('slow');
    } else {
        $('.wk_checkout_google_config').hide('slow');
    }
});

$(document).ready(function() {
    if ($('input[name=wk_checkout_google_login]:checked').val() == '1') {
        $('.wk_checkout_google_config').show('slow');
    } else {
        $('.wk_checkout_google_config').hide('slow');
    }

    // Terms n Condition on load
    if ($('input[name=wk_checkout_terms_service]:checked').val() == '1') {
        $('.wk_checkout_terms_option').show('slow');
    } else {
        $('.wk_checkout_terms_option').hide('slow');
    }

    // Who bought also bought
    if ($('input[name=wk_checkout_cart_also_bought]:checked').val() == '1') {
        $('.wk_checkout_also_bought_number').show('slow');
    } else {
        $('.wk_checkout_also_bought_number').hide('slow');
    }

});
// ----- End of code ----------------------------------


// Delivery Address required field
$(document).on('click', '.wk_delivery_req_field', function() {
    if ($(this).attr('data-required') == 1) {
        if ($(this).is(':checked')) {
            var field = $(this).attr('data-field-value');
            $('#' + field).attr('checked', 'checked');
        }
    } else {
        if ($(this).is(':checked')) {
            // var field = $(this).attr('data-field-value');
            // $('#'+field).attr('checked', 'checked');
        } else {
            var field = $(this).attr('data-field-value');
            $('#' + field).removeAttr('checked', 'checked');
        }
    }
});

// Terms n Condition on change
$(document).on('change', 'input[name=wk_checkout_terms_service]', function() {
    if ($(this).val() == '1') {
        $('.wk_checkout_terms_option').show('slow');
    } else {
        $('.wk_checkout_terms_option').hide('slow');
    }
});

// Who bought also bought
$(document).on('change', 'input[name=wk_checkout_cart_also_bought]', function() {
    if ($(this).val() == '1') {
        $('.wk_checkout_also_bought_number').show('slow');
    } else {
        $('.wk_checkout_also_bought_number').hide('slow');
    }
});


$.fn.mColorPicker.defaults.imageFolder = '../img/admin/';