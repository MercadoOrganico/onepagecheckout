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

<article class="box wkrelativeposition">

    <div class="wk-heading-img">
        {* Vinícius - 07/07/2021 - Início *}
        {* <div class="wk-user-icon wk-sprit wk-left"></div>
			<h4 class="wk-left">{l s='Your Details' mod='wkonepagecheckout'}</h4> *}
        <div class="wk-user-icon wk-sprit"></div>
        <h4 class="">{l s='Your Details' mod='wkonepagecheckout'}</h4>
        {* Vinícius - 07/07/2021 - Fim *}
    </div>

    {* Vinícius - 07/07/2021 - Início *}
    {* <div class="col-md-12 col-sm-12 col-xs-12"> *}
    <div class="user-info-container mb-1">
    {* Vinícius - 07/07/2021 - Fim *}
    
    {if $customer.is_logged && !$customer.is_guest}
        
        {* Vinícius - 07/07/2021 - Início *}
        {* <div class="col-md-9 col-sm-6 col-xs-6"> *}
        <div class="">
        {* Vinícius - 07/07/2021 - Fim *}
        <a href="{$myaccount}"><span>{$customer.firstname} {$customer.lastname}</span></a>
        <p>{$customer.email}</p>
        </div>
        
        {* Vinícius - 07/07/2021 - Início *}
        {* <div class="col-md-3 col-sm-6 col-xs-6 wk-log-btn"> *}
        <div class="">
        {* Vinícius - 07/07/2021 - Fim *}
                <a href="{$logout}" class="btn btn-primary logout">{l s='Logout' mod='wkonepagecheckout'}</a>
            </div>

        {else}
            {include file='module:wkonepagecheckout/views/templates/front/content/_partials/wk_login.tpl'}
        {/if}

    </div>

    {if $customer.is_logged && !$customer.is_guest}
        <!-- If customer is login -->
        {block name='wk-customer-address'}
            {include file='module:wkonepagecheckout/views/templates/front/content/_partials/wk-myaccount.tpl'}
        {/block}
    {/if}

    <div id="wkcustomer_info"></div>
</article>
{* Adriana - 08/09/2020 - fim *}

<script src="https://apis.google.com/js/api:client.js"></script>
<script>
    if (typeof wk_google_app_key !== 'undefined' && wk_google_app_key) {
        // do not write this code on js file because there is facebook library issue on js file
        // signin with google start
        // Load the google SDK asynchronously
        var googleUser = {};
        var startApp = function() {
            gapi.load('auth2', function() {
                // Retrieve the singleton for the GoogleAuth library and set up the client.
                auth2 = gapi.auth2.init({
                    client_id: wk_google_app_key,
                    cookiepolicy: 'single_host_origin',
                    // Request scopes in addition to 'profile' and 'email'
                });
                attachSignin(document.getElementById('customGmailBtn'));
            });
        };

        // this function called when user will allow access their info
        function attachSignin(element) {
            if (element) {
                auth2.attachClickHandler(element, {},
                    function(googleUser) {
                        proceedLogin(googleUser.getBasicProfile().getGivenName(), googleUser.getBasicProfile()
                            .getFamilyName(), googleUser.getBasicProfile().getEmail());
                    },
                    function(error) {
                        alert(user_cancel);
                    }
                );
            }
        }
        startApp();
        // signin with google end here
    }
</script>