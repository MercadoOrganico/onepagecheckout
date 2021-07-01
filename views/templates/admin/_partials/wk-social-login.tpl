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

<form action="{$currentIndex}" class="defaultForm form-horizontal" method="post" enctype="multipart/form-data">
    <div class="form-wrapper">
        <div class="form-group">
            <label class="control-label col-lg-3">
                <span title="" data-html="true" data-toggle="tooltip" class="label-tooltip" data-original-title="{l s='Allow customers to login using social profiles' mod='wkonepagecheckout'}">{l s='Allow Social Login : ' mod='wkonepagecheckout'}</span>
            </label>
            <div class="col-lg-9 ">
                <span class="switch prestashop-switch fixed-width-lg">
                    <input type="radio" name="wk_checkout_social_login" id="wk_checkout_social_login_on" value="1"
                    {if isset($smarty.post.wk_checkout_social_login) && $smarty.post.wk_checkout_social_login == 1}checked="checked"
                    {else if isset($configValues) && $configValues.WK_CHECKOUT_SOCIAL_LOGIN == 1}checked="checked"
                    {else if !isset($smarty.post.wk_checkout_social_login)}checked="checked"{/if}>
                    <label for="wk_checkout_social_login_on">{l s='Yes' mod='wkonepagecheckout'}</label>
                    {if isset($configValues)}
                    <input type="radio" name="wk_checkout_social_login" id="wk_checkout_social_login_off" value="0"
                    {if $configValues.WK_CHECKOUT_SOCIAL_LOGIN == '0'}checked="checked"
                    {else if isset($smarty.post.wk_checkout_social_login) && $smarty.post.wk_checkout_social_login == '0'}checked="checked"{/if}>
                    {else}
                    <input type="radio" name="wk_checkout_social_login" id="wk_checkout_social_login_off" value="0" {if isset($smarty.post.wk_checkout_social_login) && $smarty.post.wk_checkout_social_login == '0'}checked="checked"{/if}>
                    {/if}
                    <label for="wk_checkout_social_login_off">{l s='No' mod='wkonepagecheckout'}</label>
                    <a class="slide-button btn"></a>
                </span>
                <div class="help-block">{l s='Allow login by social profiles' mod='wkonepagecheckout'}</div>
            </div>
        </div>
        <div class="wk-social-login-tabs">
            <div class="form-group">
                <label class="control-label col-lg-3">
                    <span title="" data-html="true" data-toggle="tooltip" class="label-tooltip" data-original-title="{l s='Allow customer to login using facebook' mod='wkonepagecheckout'}">{l s='Facebook Login : ' mod='wkonepagecheckout'}</span>
                </label>
                <div class="col-lg-9 ">
                    <span class="switch prestashop-switch fixed-width-lg">
                        <input type="radio" name="wk_checkout_facebook_login" id="wk_checkout_facebook_login_on" value="1"
                        {if isset($smarty.post.wk_checkout_facebook_login) && $smarty.post.wk_checkout_facebook_login == 1}checked="checked"
                        {else if isset($configValues) && $configValues.WK_CHECKOUT_FACEBOOK_LOGIN == 1}checked="checked"
                        {else if !isset($smarty.post.wk_checkout_facebook_login)}checked="checked"{/if}>
                        <label for="wk_checkout_facebook_login_on">{l s='Yes' mod='wkonepagecheckout'}</label>
                        {if isset($configValues)}
                        <input type="radio" name="wk_checkout_facebook_login" id="wk_checkout_facebook_login_off" value="0" {if $configValues.WK_CHECKOUT_FACEBOOK_LOGIN == '0'}checked="checked"{else if isset($smarty.post.wk_checkout_facebook_login) && $smarty.post.wk_checkout_facebook_login == '0'}checked="checked"{/if}>
                        {else}
                        <input type="radio" name="wk_checkout_facebook_login" id="wk_checkout_facebook_login_off" value="0" {if isset($smarty.post.wk_checkout_facebook_login) && $smarty.post.wk_checkout_facebook_login == '0'}checked="checked"{/if}>
                        {/if}
                        <label for="wk_checkout_facebook_login_off">{l s='No' mod='wkonepagecheckout'}</label>
                        <a class="slide-button btn"></a>
                    </span>
                </div>
            </div>
            <div class="wk_checkout_fb_config">
                <div class="form-group">
                    <label class="control-label col-lg-3 required">
                        <span title="" data-html="true" data-toggle="tooltip" class="label-tooltip" data-original-title="{l s='Facebook app id' mod='wkonepagecheckout'}">{l s='Facebook App ID : ' mod='wkonepagecheckout'}</span>
                    </label>
                    <div class="col-lg-4">
                        <input type="text" name="wk_checkout_fb_app_id" id="wk_checkout_fb_app_id" value="{$configValues.WK_CHECKOUT_FB_APP_ID}">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-lg-3 required">
                        <span title="" data-html="true" data-toggle="tooltip" class="label-tooltip" data-original-title="{l s='Facebook secret key' mod='wkonepagecheckout'}">{l s='Facebook Secret Key : ' mod='wkonepagecheckout'}</span>
                    </label>
                    <div class="col-lg-4">
                        <input type="text" name="wk_checkout_fb_secret_key" id="wk_checkout_fb_secret_key" value="{$configValues.WK_CHECKOUT_FB_SECRET_KEY}">
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-lg-3">
                    <span title="" data-html="true" data-toggle="tooltip" class="label-tooltip" data-original-title="{l s='Allow customers to login by google' mod='wkonepagecheckout'}">{l s='Google Login : ' mod='wkonepagecheckout'}</span>
                </label>
                <div class="col-lg-9 ">
                    <span class="switch prestashop-switch fixed-width-lg">
                        <input type="radio" name="wk_checkout_google_login" id="wk_checkout_google_login_on" value="1"
                        {if isset($smarty.post.wk_checkout_google_login) && $smarty.post.wk_checkout_google_login == 1}checked="checked"
                        {else if isset($configValues) && $configValues.WK_CHECKOUT_GOOGLE_LOGIN == 1}checked="checked"
                        {else if !isset($smarty.post.wk_checkout_google_login)}checked="checked"{/if}>
                        <label for="wk_checkout_google_login_on">{l s='Yes' mod='wkonepagecheckout'}</label>
                        {if isset($configValues)}
                        <input type="radio" name="wk_checkout_google_login" id="wk_checkout_google_login_off" value="0" {if $configValues.WK_CHECKOUT_GOOGLE_LOGIN == '0'}checked="checked"{else if isset($smarty.post.wk_checkout_google_login) && $smarty.post.wk_checkout_google_login == '0'}checked="checked"{/if}>
                        {else}
                        <input type="radio" name="wk_checkout_google_login" id="wk_checkout_google_login_off" value="0" {if isset($smarty.post.wk_checkout_google_login) && $smarty.post.wk_checkout_google_login == '0'}checked="checked"{/if}>
                        {/if}
                        <label for="wk_checkout_google_login_off">{l s='No' mod='wkonepagecheckout'}</label>
                        <a class="slide-button btn"></a>
                    </span>
                </div>
            </div>
            <div class="wk_checkout_google_config">
                <div class="form-group">
                    <label class="control-label col-lg-3 required">
                        <span title="" data-html="true" data-toggle="tooltip" class="label-tooltip" data-original-title="{l s='Google app key' mod='wkonepagecheckout'}">{l s='Google API Key : ' mod='wkonepagecheckout'}</span>
                    </label>
                    <div class="col-lg-4">
                        <input type="text" name="wk_checkout_google_app_key" id="wk_checkout_google_app_key" value="{$configValues.WK_CHECKOUT_GOOGLE_APP_KEY}">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-lg-3 required">
                        <span title="" data-html="true" data-toggle="tooltip" class="label-tooltip" data-original-title="{l s='Google secret key' mod='wkonepagecheckout'}">{l s='Google Secret Key : ' mod='wkonepagecheckout'}</span>
                    </label>
                    <div class="col-lg-4">
                        <input type="text" name="wk_checkout_google_secret_key" id="wk_checkout_google_secret_key" value="{$configValues.WK_CHECKOUT_GOOGLE_SECRET_KEY}">
                    </div>
                </div>
            </div>
            {*<div class="form-group">
                <label class="control-label col-lg-3 required">
                    <span title="" data-html="true" data-toggle="tooltip" class="label-tooltip" data-original-title="{l s='Allow guest to proceed cart' mod='wkonepagecheckout'}">{l s='Twitter Login : ' mod='wkonepagecheckout'}</span>
                </label>
                <div class="col-lg-9 ">
                    <span class="switch prestashop-switch fixed-width-lg">
                        <input type="radio" name="wk_checkout_social_login" id="wk_checkout_social_login_on" value="1"
                        {if isset($smarty.post.wk_checkout_social_login) && $smarty.post.wk_checkout_social_login == 1}checked="checked"
                        {else if isset($configValues) && $configValues.WK_CHECKOUT_SOCIAL_LOGIN == 1}checked="checked"
                        {else if !isset($smarty.post.wk_checkout_social_login)}checked="checked"{/if}>
                        <label for="wk_checkout_social_login_on">{l s='Yes' mod='wkonepagecheckout'}</label>
                        {if isset($configValues)}
                        <input type="radio" name="wk_checkout_social_login" id="wk_checkout_social_login_off" value="0" {if $configValues.WK_CHECKOUT_SOCIAL_LOGIN == '0'}checked="checked"{else if isset($smarty.post.wk_checkout_social_login) && $smarty.post.wk_checkout_social_login == '0'}checked="checked"{/if}>
                        {else}
                        <input type="radio" name="wk_checkout_social_login" id="wk_checkout_guest_allow_off" value="0" {if isset($smarty.post.wk_checkout_social_login) && $smarty.post.wk_checkout_social_login == '0'}checked="checked"{/if}>
                        {/if}
                        <label for="wk_checkout_social_login_off">{l s='No' mod='wkonepagecheckout'}</label>
                        <a class="slide-button btn"></a>
                    </span>
                    <div class="help-block">{l s='Allow login by social profiles' mod='wkonepagecheckout'}</div>
                </div>
            </div>*}
        </div>
    </div>
    <div class="panel-footer">
        <button type="submit" name="submitSocialLogin" class="btn btn-default pull-right">
            <i class="process-icon-save"></i> {l s='Save' mod='wkonepagecheckout'}
        </button>
    </div>
</form>
