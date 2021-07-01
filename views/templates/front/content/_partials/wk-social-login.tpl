{**
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
*}

<script src="https://apis.google.com/js/api:client.js"></script>
<div id="wkonepagecheckoutBlock">
	<a onclick="return fblogin();" class="btn button button-small" href="javascript:void(0)" id="customFbBtn">
		<span><img title="{l s='Connect with Facebook' mod='wkonepagecheckout'}" alt="{l s='Facebook' mod='wkonepagecheckout'}" src="{$icon_path}facebook_icon.png"> <b class="btn_text">{l s='Login' mod='wkonepagecheckout'}</b></span>
	</a>

	<a id="customGmailBtn" href="javascript:void(0)" class="btn button button-small">
		<span><img title="{l s='Connect with Google' mod='wkonepagecheckout'}" alt="{l s='Google' mod='wkonepagecheckout'}" width="30" height="30" src="{$icon_path}google_icon.png"> <b class="btn_text">{l s='Login' mod='wkonepagecheckout'}</b></span>
	</a>
</div>
<script type="text/javascript">
	var error_msg = '{l s='User cancelled login or did not fully authorize.' js=1 mod='wkonepagecheckout'}';
	var firstNameReq = '{l s='First name not found.' js=1 mod='wkonepagecheckout'}';
	var lastNameReq = '{l s='last name not found.' js=1 mod='wkonepagecheckout'}';
	var emailReq = '{l s='Email not found.' js=1 mod='wkonepagecheckout'}';

    // do not write this code on js file because there is facebook library issue on js file
    // signin with google start
	// Load the google SDK asynchronously
	var googleUser = {};
	var startApp = function() {
		gapi.load('auth2', function(){
			// Retrieve the singleton for the GoogleAuth library and set up the client.
			auth2 = gapi.auth2.init({
				client_id: "{$wk_google_app_client_id}",
				cookiepolicy: 'single_host_origin',
			// Request scopes in addition to 'profile' and 'email'
			});
			attachSignin(document.getElementById('customGmailBtn'));
		});
	};

	// this function called when user will allow access their info
	function attachSignin(element) {
		auth2.attachClickHandler(element, {},
			function(googleUser) {
				checkAndLogin(googleUser.getBasicProfile().getGivenName(), googleUser.getBasicProfile().getFamilyName(), googleUser.getBasicProfile().getEmail());
			}, function(error) {
				alert(error_msg);
			}
		);
	}
	// signin with google end here



	// signin with facebook start here
	// Load the facebook SDK asynchronously start
	window.fbAsyncInit = function() {
		FB.init({
			appId      : "{$wk_fb_app_id}",
			cookie     : true,
			xfbml      : true,
			status     : true,
			version    : "v{$wk_fb_app_version}"
		});
	};

	(function(d, s, id) {
		var js, fjs = d.getElementsByTagName(s)[0];
		if (d.getElementById(id)) return;
		js = d.createElement(s); js.id = id;
		js.src = "//connect.facebook.net/en_US/all.js";
		fjs.parentNode.insertBefore(js, fjs);
	}(document, 'script', 'facebook-jssdk'));
	// Load the facebook SDK asynchronously end


	// when login button clicked this function will called
	function fblogin(){
		FB.login(function(response) {
			if (response.status == 'connected') {
				FB.api('/me?fields=first_name,last_name,email', function(response) {
					// Validate and call checkAndLogin
					var isValidated = validateFacebookResponse(response);
					if (isValidated == true) {
						checkAndLogin(response.first_name, response.last_name, response.email);
					}
				});
			} else {
				alert(error_msg);
			}
		}, { scope: 'public_profile, email' });
		return false;
	}

	// validate facebook user details
	function validateFacebookResponse(response)
	{
		if (response.first_name == '' || response.first_name === undefined) {
			deleteFacebookPermissions();
			alert(error_msg);
		} else if (response.last_name == '' || response.last_name === undefined) {
			deleteFacebookPermissions();
			alert(error_msg);
		} else if (response.email == '' || response.email === undefined) {
			deleteFacebookPermissions();
			alert(emailReq);
		} else {
			return true;
		}

		return false;
	}

	// delete facebook app all permissions
	function deleteFacebookPermissions()
	{
		FB.api("/me/permissions", "DELETE");
	}

	// this function check user by email and id user find out, login that user and if not signup and login
	function checkAndLogin(first_name, last_name, email) {
		if (first_name && last_name && email) {
			$.ajax({
				type: "POST",
				url: "{$link->getModulelink('wkonepagecheckout', 'processCustomer')}",
				async: false,
				data: {
					first_name: first_name,
					last_name: last_name,
					email: email
				},
				success: function(result){
					window.location.href = result;
				}
			});
		}
	}
	startApp();
</script>
