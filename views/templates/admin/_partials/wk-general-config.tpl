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
                <span title="" data-html="true" data-toggle="tooltip" class="label-tooltip" data-original-title="{l s='If No, then module functionality gets disabled' mod='wkonepagecheckout'}">{l s='Enable One Page Checkout : ' mod='wkonepagecheckout'}</span>
            </label>
            <div class="col-lg-9 ">
                <span class="switch prestashop-switch fixed-width-lg">
                    <input type="radio" name="wk_checkout_mode" id="wk_checkout_mode_on" value="1"
                    {if isset($smarty.post.wk_checkout_mode) && $smarty.post.wk_checkout_mode == 1}checked="checked"
                    {else if isset($configValues) && $configValues.WK_CHECKOUT_MODE == 1}checked="checked"
                    {else if !isset($smarty.post.wk_checkout_mode)}checked="checked"{/if}>
                    <label for="wk_checkout_mode_on">{l s='Yes' mod='wkonepagecheckout'}</label>
                    {if isset($configValues)}
                    <input type="radio" name="wk_checkout_mode" id="wk_checkout_mode_off" value="0" {if $configValues.WK_CHECKOUT_MODE == '0'}checked="checked"{else if isset($smarty.post.wk_checkout_mode) && $smarty.post.wk_checkout_mode == '0'}checked="checked"{/if}>
                    {else}
                    <input type="radio" name="wk_checkout_mode" id="wk_checkout_mode_off" value="0" {if isset($smarty.post.wk_checkout_mode) && $smarty.post.wk_checkout_mode == '0'}checked="checked"{/if}>
                    {/if}
                    <label for="wk_checkout_mode_off">{l s='No' mod='wkonepagecheckout'}</label>
                    <a class="slide-button btn"></a>
                </span>
            </div>
        </div>
        <div class="wk-general-setting">
            <div class="form-group">
                <label class="control-label col-lg-3">
                    <span title="" data-html="true" data-toggle="tooltip" class="label-tooltip" data-original-title="{l s='If enabled, then onepagecheckout will only work on specific IP Address' mod='wkonepagecheckout'}">{l s='Sandbox Mode : ' mod='wkonepagecheckout'}</span>
                </label>
                <div class="col-lg-9 ">
                    <span class="switch prestashop-switch fixed-width-lg">
                        <input type="radio" name="wk_checkout_sandbox" id="wk_checkout_sandbox_on" value="1"
                        {if isset($smarty.post.wk_checkout_sandbox) && $smarty.post.wk_checkout_sandbox == 1}checked="checked"
                        {else if isset($configValues) && $configValues.WK_CHECKOUT_SANDBOX == 1}checked="checked"
                        {else if !isset($smarty.post.wk_checkout_sandbox)}checked="checked"{/if}>
                        <label for="wk_checkout_sandbox_on">{l s='Yes' mod='wkonepagecheckout'}</label>
                        {if isset($configValues)}
                        <input type="radio" name="wk_checkout_sandbox" id="wk_checkout_sandbox_off" value="0" {if $configValues.WK_CHECKOUT_SANDBOX == '0'}checked="checked"{else if isset($smarty.post.wk_checkout_sandbox) && $smarty.post.wk_checkout_sandbox == '0'}checked="checked"{/if}>
                        {else}
                        <input type="radio" name="wk_checkout_sandbox" id="wk_checkout_sandbox_off" value="0" {if isset($smarty.post.wk_checkout_sandbox) && $smarty.post.wk_checkout_sandbox == '0'}checked="checked"{/if}>
                        {/if}
                        <label for="wk_checkout_sandbox_off">{l s='No' mod='wkonepagecheckout'}</label>
                        <a class="slide-button btn"></a>
                    </span>
                    <div class="help-block">{l s='Check one page checkout module on specific IP Address' mod='wkonepagecheckout'}</div>
                </div>
            </div>
            <div class="form-group wk-checkout-ips wkhide">
                <label class="control-label col-lg-3 required">
                    <span title="" data-html="true" data-toggle="tooltip" class="label-tooltip" data-original-title="{l s='IP addresses on which one page checkout is applicable' mod='wkonepagecheckout'}">{l s='Add IP Address : ' mod='wkonepagecheckout'}</span>
                </label>
                <div class="col-lg-9">
                    <div class="col-lg-6">
                        <input type="hidden" value="{if isset($ip)}{$ip}{/if}" name="wk_ip_address" id="wk_ip_address">
                        <input type="text" value="{$configValues.WK_CHECKOUT_IPS}" name="wk_checkout_ip_address" id="wk_checkout_ip_address">
                    </div>
                    <div class="col-lg-2">
                        <button onclick="addRemoteAddr();" class="btn btn-default" type="button"><i class="icon-plus"></i> {l s=' Add my IP' mod='wkonepagecheckout'}</button>
                    </div>
                    <div class="help-block col-lg-9">{l s='Add multiple IPs separated by comma(,)' mod='wkonepagecheckout'}</div>
                </div>
            </div>
        </div>
    </div>
    <div class="panel-footer">
        <button type="submit" name="submitGeneralConfig" class="btn btn-default pull-right">
            <i class="process-icon-save"></i> {l s='Save' mod='wkonepagecheckout'}
        </button>
    </div>
</form>
