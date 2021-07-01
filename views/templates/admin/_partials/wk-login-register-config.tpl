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
                <span title="" data-html="true" data-toggle="tooltip" class="label-tooltip" data-original-title="{l s='Allow guest visitors to place an order without registering' mod='wkonepagecheckout'}">{l s='Enable Guest Checkout : ' mod='wkonepagecheckout'}</span>
            </label>
            <div class="col-lg-9 ">
                <span class="switch prestashop-switch fixed-width-lg">
                    <input type="radio" name="wk_checkout_guest_allow" id="wk_checkout_guest_allow_on" value="1"
                    {if isset($smarty.post.wk_checkout_guest_allow) && $smarty.post.wk_checkout_guest_allow == 1}checked="checked"
                    {else if isset($configValues) && $configValues.WK_CHECKOUT_GUEST_ALLOW == 1}checked="checked"
                    {else if !isset($smarty.post.wk_checkout_guest_allow)}checked="checked"{/if}>
                    <label for="wk_checkout_guest_allow_on">{l s='Yes' mod='wkonepagecheckout'}</label>
                    {if isset($configValues)}
                    <input type="radio" name="wk_checkout_guest_allow" id="wk_checkout_guest_allow_off" value="0" {if $configValues.WK_CHECKOUT_GUEST_ALLOW == '0'}checked="checked"{else if isset($smarty.post.wk_checkout_guest_allow) && $smarty.post.wk_checkout_guest_allow == '0'}checked="checked"{/if}>
                    {else}
                    <input type="radio" name="wk_checkout_guest_allow" id="wk_checkout_guest_allow_off" value="0" {if isset($smarty.post.wk_checkout_guest_allow) && $smarty.post.wk_checkout_guest_allow == '0'}checked="checked"{/if}>
                    {/if}
                    <label for="wk_checkout_guest_allow_off">{l s='No' mod='wkonepagecheckout'}</label>
                    <a class="slide-button btn"></a>
                </span>
            </div>
        </div>
        <div class="form-group">
            <label class="control-label col-lg-3">
                <span title="" data-html="true" data-toggle="tooltip" class="label-tooltip" data-original-title="{l s='This group will be user\'s default group. Only the discount for the selected group will be applied to this customer' mod='wkonepagecheckout'}">{l s='Default Customer Group For New Customers : ' mod='wkonepagecheckout'}</span>
            </label>
            <div class="col-lg-4">
                <select name="wk_checkout_default_group" id="wk_checkout_default_group" class="form-control">
                    {if isset($getGroups)}
                        {foreach $getGroups as $group}
                            <option value="{$group.id_group}" {if $configValues.WK_CHECKOUT_DEFAULT_GROUP == $group.id_group}selected="selected"{/if}>{$group.name}</option>
                        {/foreach}
                    {/if}
                </select>
            </div>
        </div>
        {* <div class="form-group">
            <label class="control-label col-lg-3">
                <span title="" data-html="true" data-toggle="tooltip" class="label-tooltip" data-original-title="{l s='Show button to save address before checkout only for logged in customers' mod='wkonepagecheckout'}">{l s='Show save button for address : ' mod='wkonepagecheckout'}</span>
            </label>
            <div class="col-lg-9 ">
                <span class="switch prestashop-switch fixed-width-lg">
                    <input type="radio" name="wk_checkout_show_address_button" id="wk_checkout_show_address_button_on" value="1"
                    {if isset($smarty.post.wk_checkout_show_address_button) && $smarty.post.wk_checkout_show_address_button == 1}checked="checked"
                    {else if isset($configValues) && $configValues.WK_CHECKOUT_SHOW_ADDRESS_BUTTON == 1}checked="checked"
                    {else if !isset($smarty.post.wk_checkout_show_address_button)}checked="checked"{/if}>
                    <label for="wk_checkout_show_address_button_on">{l s='Yes' mod='wkonepagecheckout'}</label>
                    {if isset($configValues)}
                    <input type="radio" name="wk_checkout_show_address_button" id="wk_checkout_show_address_button_off" value="0" {if $configValues.WK_CHECKOUT_SHOW_ADDRESS_BUTTON == '0'}checked="checked"{else if isset($smarty.post.wk_checkout_show_address_button) && $smarty.post.wk_checkout_show_address_button == '0'}checked="checked"{/if}>
                    {else}
                    <input type="radio" name="wk_checkout_show_address_button" id="wk_checkout_guest_allow_off" value="0" {if isset($smarty.post.wk_checkout_show_address_button) && $smarty.post.wk_checkout_show_address_button == '0'}checked="checked"{/if}>
                    {/if}
                    <label for="wk_checkout_show_address_button_off">{l s='No' mod='wkonepagecheckout'}</label>
                    <a class="slide-button btn"></a>
                </span>
            </div>
        </div> *}
        <div class="form-group">
            <label class="control-label col-lg-3">
                <span title="" data-html="true" data-toggle="tooltip" class="label-tooltip" data-original-title="{l s='Inline validation will check when customer move cursor from the input field' mod='wkonepagecheckout'}">{l s='Inline validation will check immediately to the input fields of address : ' mod='wkonepagecheckout'}</span>
            </label>
            <div class="col-lg-9 ">
                <span class="switch prestashop-switch fixed-width-lg">
                    <input type="radio" name="wk_checkout_inline_validation" id="wk_checkout_inline_validation_on" value="1"
                    {if isset($smarty.post.wk_checkout_inline_validation) && $smarty.post.wk_checkout_inline_validation == 1}checked="checked"
                    {else if isset($configValues) && $configValues.WK_CHECKOUT_INLINE_VALIDATION == 1}checked="checked"
                    {else if !isset($smarty.post.wk_checkout_inline_validation)}checked="checked"{/if}>
                    <label for="wk_checkout_inline_validation_on">{l s='Yes' mod='wkonepagecheckout'}</label>
                    {if isset($configValues)}
                    <input type="radio" name="wk_checkout_inline_validation" id="wk_checkout_inline_validation_off" value="0" {if $configValues.WK_CHECKOUT_INLINE_VALIDATION == '0'}checked="checked"{else if isset($smarty.post.wk_checkout_inline_validation) && $smarty.post.wk_checkout_inline_validation == '0'}checked="checked"{/if}>
                    {else}
                    <input type="radio" name="wk_checkout_inline_validation" id="wk_checkout_inline_validation_off" value="0" {if isset($smarty.post.wk_checkout_inline_validation) && $smarty.post.wk_checkout_inline_validation == '0'}checked="checked"{/if}>
                    {/if}
                    <label for="wk_checkout_inline_validation_off">{l s='No' mod='wkonepagecheckout'}</label>
                    <a class="slide-button btn"></a>
                </span>
            </div>
        </div>
        <div class="form-group">
            <label class="control-label col-lg-3">
                <span title="" data-html="true" data-toggle="tooltip" class="label-tooltip" data-original-title="{l s='Customer can add their social title during registration' mod='wkonepagecheckout'}">{l s='Show social title : ' mod='wkonepagecheckout'}</span>
            </label>
            <div class="col-lg-9 ">
                <span class="switch prestashop-switch fixed-width-lg">
                    <input type="radio" name="wk_checkout_social_title" id="wk_checkout_social_title_on" value="1"
                    {if isset($smarty.post.wk_checkout_social_title) && $smarty.post.wk_checkout_social_title == 1}checked="checked"
                    {else if isset($configValues) && $configValues.WK_CHECKOUT_SOCIAL_TITLE == 1}checked="checked"
                    {else if !isset($smarty.post.wk_checkout_social_title)}checked="checked"{/if}>
                    <label for="wk_checkout_social_title_on">{l s='Yes' mod='wkonepagecheckout'}</label>
                    {if isset($configValues)}
                    <input type="radio" name="wk_checkout_social_title" id="wk_checkout_social_title_off" value="0" {if $configValues.WK_CHECKOUT_SOCIAL_TITLE == '0'}checked="checked"{else if isset($smarty.post.wk_checkout_social_title) && $smarty.post.wk_checkout_social_title == '0'}checked="checked"{/if}>
                    {else}
                    <input type="radio" name="wk_checkout_social_title" id="wk_checkout_social_title_off" value="0" {if isset($smarty.post.wk_checkout_social_title) && $smarty.post.wk_checkout_social_title == '0'}checked="checked"{/if}>
                    {/if}
                    <label for="wk_checkout_social_title_off">{l s='No' mod='wkonepagecheckout'}</label>
                    <a class="slide-button btn"></a>
                </span>
            </div>
        </div>
        <div class="form-group">
            <label class="control-label col-lg-3">
                <span title="" data-html="true" data-toggle="tooltip" class="label-tooltip" data-original-title="{l s='Ask date of birth from the customer' mod='wkonepagecheckout'}">{l s='Ask Date of Birth : ' mod='wkonepagecheckout'}</span>
            </label>
            <div class="col-lg-9 ">
                <span class="switch prestashop-switch fixed-width-lg">
                    <input type="radio" name="wk_checkout_dob" id="wk_checkout_dob_on" value="1"
                    {if isset($smarty.post.wk_checkout_dob) && $smarty.post.wk_checkout_dob == 1}checked="checked"
                    {else if isset($configValues) && $configValues.WK_CHECKOUT_DOB == 1}checked="checked"
                    {else if !isset($smarty.post.wk_checkout_dob)}checked="checked"{/if}>
                    <label for="wk_checkout_dob_on">{l s='Yes' mod='wkonepagecheckout'}</label>
                    {if isset($configValues)}
                    <input type="radio" name="wk_checkout_dob" id="wk_checkout_dob_off" value="0" {if $configValues.WK_CHECKOUT_DOB == '0'}checked="checked"{else if isset($smarty.post.wk_checkout_dob) && $smarty.post.wk_checkout_dob == '0'}checked="checked"{/if}>
                    {else}
                    <input type="radio" name="wk_checkout_dob" id="wk_checkout_dob_off" value="0" {if isset($smarty.post.wk_checkout_dob) && $smarty.post.wk_checkout_dob == '0'}checked="checked"{/if}>
                    {/if}
                    <label for="wk_checkout_dob_off">{l s='No' mod='wkonepagecheckout'}</label>
                    <a class="slide-button btn"></a>
                </span>
            </div>
        </div>
        <div class="form-group">
            <label class="control-label col-lg-3">
                <span title="" data-html="true" data-toggle="tooltip" class="label-tooltip" data-original-title="{l s='Allow customers to receive your offers' mod='wkonepagecheckout'}">{l s='Allow to opt-in option : ' mod='wkonepagecheckout'}</span>
            </label>
            <div class="col-lg-9 ">
                <span class="switch prestashop-switch fixed-width-lg">
                    <input type="radio" name="wk_checkout_optin" id="wk_checkout_optin_on" value="1"
                    {if isset($smarty.post.wk_checkout_optin) && $smarty.post.wk_checkout_optin == 1}checked="checked"
                    {else if isset($configValues) && $configValues.WK_CHECKOUT_OPTIN == 1}checked="checked"
                    {else if !isset($smarty.post.wk_checkout_optin)}checked="checked"{/if}>
                    <label for="wk_checkout_optin_on">{l s='Yes' mod='wkonepagecheckout'}</label>
                    {if isset($configValues)}
                    <input type="radio" name="wk_checkout_optin" id="wk_checkout_optin_off" value="0" {if $configValues.WK_CHECKOUT_OPTIN == '0'}checked="checked"{else if isset($smarty.post.wk_checkout_optin) && $smarty.post.wk_checkout_optin == '0'}checked="checked"{/if}>
                    {else}
                    <input type="radio" name="wk_checkout_optin" id="wk_checkout_optin_off" value="0" {if isset($smarty.post.wk_checkout_optin) && $smarty.post.wk_checkout_optin == '0'}checked="checked"{/if}>
                    {/if}
                    <label for="wk_checkout_optin_off">{l s='No' mod='wkonepagecheckout'}</label>
                    <a class="slide-button btn"></a>
                </span>
            </div>
        </div>
        <div class="form-group">
            <label class="control-label col-lg-3">
                <span title="" data-html="true" data-toggle="tooltip" class="label-tooltip" data-original-title="{l s='Allow customers to receive your newsletters' mod='wkonepagecheckout'}">{l s='Allow customers to receive your newsletter : ' mod='wkonepagecheckout'}</span>
            </label>
            <div class="col-lg-9 ">
                <span class="switch prestashop-switch fixed-width-lg">
                    <input type="radio" name="wk_checkout_newslatter" id="wk_checkout_newslatter_on" value="1"
                    {if isset($smarty.post.wk_checkout_newslatter) && $smarty.post.wk_checkout_newslatter == 1}checked="checked"
                    {else if isset($configValues) && $configValues.WK_CHECKOUT_NEWSLATTER == 1}checked="checked"
                    {else if !isset($smarty.post.wk_checkout_newslatter)}checked="checked"{/if}>
                    <label for="wk_checkout_newslatter_on">{l s='Yes' mod='wkonepagecheckout'}</label>
                    {if isset($configValues)}
                    <input type="radio" name="wk_checkout_newslatter" id="wk_checkout_newslatter_off" value="0" {if $configValues.WK_CHECKOUT_NEWSLATTER == '0'}checked="checked"{else if isset($smarty.post.wk_checkout_newslatter) && $smarty.post.wk_checkout_newslatter == '0'}checked="checked"{/if}>
                    {else}
                    <input type="radio" name="wk_checkout_newslatter" id="wk_checkout_newslatter_off" value="0" {if isset($smarty.post.wk_checkout_newslatter) && $smarty.post.wk_checkout_newslatter == '0'}checked="checked"{/if}>
                    {/if}
                    <label for="wk_checkout_newslatter_off">{l s='No' mod='wkonepagecheckout'}</label>
                    <a class="slide-button btn"></a>
                </span>
            </div>
        </div>
    </div>
    <div class="panel-footer">
        <button type="submit" name="submitLoginRegister" class="btn btn-default pull-right">
            <i class="process-icon-save"></i> {l s='Save' mod='wkonepagecheckout'}
        </button>
    </div>
</form>
