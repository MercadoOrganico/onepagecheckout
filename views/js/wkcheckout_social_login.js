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

if ((typeof wk_fb_app_id !== 'undefined' && typeof wk_fb_secret_key !== 'undefined') && typeof is_logged === 'undefined') {
    window.fbAsyncInit = function() {
        // FB JavaScript SDK configuration and setup
        FB.init({
            appId: wk_fb_app_id, // FB App ID
            cookie: true, // enable cookies to allow the server to access the session
            xfbml: true, // parse social plugins on this page
            version: 'v2.8' // use graph api version 2.8
        });
    };

    // Load the JavaScript SDK asynchronously
    (function(d, s, id) {
        var js, fjs = d.getElementsByTagName(s)[0];
        if (d.getElementById(id)) return;
        js = d.createElement(s);
        js.id = id;
        js.src = "//connect.facebook.net/en_US/sdk.js";
        fjs.parentNode.insertBefore(js, fjs);
    }(document, 'script', 'facebook-jssdk'));

    // Facebook login with JavaScript SDK
    function fbLogin() {
        if (typeof FB != 'undefined') {
            FB.login(function(response) {
                if (response.authResponse) {
                    // Get and display the user profile data
                    getFbUserData();
                } else {
                    showErrorMsg(user_cancel);
                    //document.getElementById('status').innerHTML = user_cancel;
                }
            }, { scope: 'email' });
        } else {
            showErrorMsg(fbConnectionError);
        }
    }

    // Fetch the user profile data from facebook
    function getFbUserData() {
        FB.api('/me', { locale: 'en_US', fields: 'id,first_name,last_name,email,gender,locale' },
            function(response) {
                var isValidated = validateFacebookResponse(response);
                if (isValidated == true) {
                    proceedLogin(response.first_name, response.last_name, response.email);
                }
            });
    }

    function validateFacebookResponse(response) {
        if (!response.first_name || response.first_name === 'undefined') {
            deleteFacebookPermissions();
            showErrorMsg(error_fname);
        } else if (!response.last_name || response.last_name === 'undefined') {
            deleteFacebookPermissions();
            showErrorMsg(error_lname);
        } else if (!response.email || response.email === 'undefined') {
            deleteFacebookPermissions();
            showErrorMsg(error_email);
        } else {
            return true;
        }

        return false;
    }

    function deleteFacebookPermissions() {
        FB.api("/me/permissions", "DELETE");
    }
}

function showErrorMsg(msg) {
    $.growl.error({ title: "", message: msg });
}

function showSuccessMsg(msg) {
    $.growl.error({ title: "", message: msg });
}

function proceedLogin(first_name, last_name, email) {
    if (first_name && last_name && email) {
        $.ajax({
            type: "POST",
            url: wkcheckout,
            async: false,
            dataType: 'json',
            data: {
                ajax: true,
                action: 'proceedLogin',
                first_name: first_name,
                last_name: last_name,
                email: email,
                token: wktoken,
            },
            success: function(result) {
                if (result == '1') {
                    window.location.reload(true);
                }
            }
        });
    }
}