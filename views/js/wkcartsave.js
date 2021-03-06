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

$(document).on('click', '#wk-add-into-cart', function() {
    var idProduct = $(this).attr('data-id-product');
    var idProductAttribute = $(this).attr('data-id-product-attribute');
    var quantity = $(this).attr('data-quantity');
    if (idProduct) {
        $.ajax({
            type: 'POST',
            url: wkmycart,
            cache: false,
            async: false,
            data: {
                'ajax': true,
                'action': 'processChangeProductInCart',
                'token': wktoken,
                'add': 1,
                'qty': quantity,
                'id_product': idProduct,
                'idProductAttribute': idProductAttribute,
            },
            beforeSend: function() {
                $('#wk-cart-loader').show();
            },
            complete: function() {
                $('#wk-cart-loader').hide();
            },
            success: function(result) {
                if (parseInt(result) == 1) {
                    window.location.href = wkorder;
                    // window.location.reload(true);
                } else if (result == '0') {
                    showErrorMessage(wkNoLongerMsg);
                    return false;
                } else if (result == '2') {
                    showErrorMessage(wkOutofStockMsg);
                    return false;
                } else if (result == '3') {
                    showErrorMessage(wkAddMsg);
                    return false;
                } else if (result == '4') {
                    showErrorMessage(wkMaxMsg);
                    return false;
                }
            },
            error: function() {},
        });
    }
});

function wkShowError(msg) {
    $.growl.error({ title: "", message: msg});
}

function wkShowSuccess(msg) {
    $.growl.notice({ title: "", message: msg});
}

$(document).on('click', '#wk-delete-cart', function() {
    var idProduct = $(this).attr('data-id-product');
    var idProductAttribute = $(this).attr('data-id-product-attribute');
    $('#wk-cart-loader-' + idProduct + '-' + idProductAttribute).show();
});

