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

{* Vinícius - 08/07/2021 - Início *}
<style>
    .payment-options {
        width: 100%;
        display: flex;
        flex-direction: column;
    }

    .custom-radio {
        border-color: #7a7a7a;
    }

    .wk-payment-info {
        border-radius: 5px;
        border: solid 1px #7a7a7a;
        margin-bottom: 10px;
    }

    .wk-shipping-list, .wk-payment-list {
        margin: 0;
    }
</style>
{* Vinícius - 08/07/2021 - Fim *}

<div class="wk-payment-method">
    <div class="wk-heading-img">
        {* Vinícius - 08/07/2021 - Início *}
        {* <div class="wk-payment-icon wk-sprit"></div>
        <h4 class="">{l s='Payment Method' mod='wkonepagecheckout'}</h4>
        <div class="wkerrorcolor wkhide" id="wkpayment-error"></div> *}
        <div class="wk-payment-icon wk-sprit"></div>
        <h4 class="">{l s='Payment Method' mod='wkonepagecheckout'}</h4>
        <div class="wkerrorcolor wkhide" id="wkpayment-error"></div>
        {* Vinícius - 08/07/2021 - Início *}
    </div>
    <div class="payment-options">
        {if $wk_is_logged == 1}
            {if isset($is_free) && $is_free}
                <input type="hidden" value="{$is_free}" id="wk_free_order" />
                <p>{l s='No payment needed for this order' mod='wkonepagecheckout'}</p>
            {/if}
            {if isset($payment_options) && $payment_options}
                <div {if $is_free}class="hidden-xs-up"{/if}>
                    {foreach from=$payment_options key="paymoduleIndex" item="module_options"}
                        <div class="row wk-payment-select" id="{$paymoduleIndex}">
                            {foreach from=$module_options item="option"}
                                <div class="wk-payment-list col-md-12 col-sm-12 col-xs-12">
                                    <div id="{$option.id}-container" class="wk-payment col-xs-1 col-sm-1 col-md-1 payment-option wkpadding">
                                        {* This is the way an option should be selected when Javascript is enabled *}
                                        <span class="custom-radio pull-xs-left">
                                            <input
                                                {if Configuration::get('WK_CHECKOUT_DEFAULT_PAYMENT') == $paymoduleIndex || $is_free}{if $option.id == 'payment-option-3'}checked="checked"{/if}{/if}
                                                    class="ps-shown-by-js {if $option.binary} binary {/if}" 
                                                    id="{$option.id}"
                                                    data-module-name="{$option.module_name}" 
                                                    name="payment-option" 
                                                    type="radio"
                                                    onchange="if (typeof wkSwitchCartPaymentOptionForSubscription != 'undefined')wkSwitchCartPaymentOptionForSubscription(this);"
                                                    required>
                                                <span></span>
                                            </span>
                                            {* This is the way an option should be selected when Javascript is disabled *}
                                            <form method="GET" class="ps-hidden-by-js">
                                                <button class="ps-hidden-by-js" type="submit" name="select_payment_option" value="{$option.id}">
                                                    {l s='Choose' mod='wkonepagecheckout'}
                                                </button>
                                            </form>
                                        </div>
                                        <div class="wk-payment-info col-md-11 col-sm-9 col-xs-9 wk-selected-payment-{$option.id} {if Configuration::get('WK_CHECKOUT_DEFAULT_PAYMENT') && (Configuration::get('WK_CHECKOUT_DEFAULT_PAYMENT') == $paymoduleIndex)}{if $option.id == 'payment-option-3'}wkSelectedBorder{/if}{/if}">
                                            <div class="row">
                                                {if Configuration::get('WK_CHECKOUT_PAYMENT_LOGO')}
                                                    <div class="col-md-3 col-xs-12 col-sm-3">
                                                        {if $option.logo}
                                                            <img src="{$option.logo}" width="50">
                                                        {else}
                                                            <img class="wk-custom-payment-icon" width="50" src="{$wk_opc_modules_dir}img/wk-icon-money.png">
                                                        {/if}
                                                    </div>
                                                {/if}
                                                <div class="col-md-9 col-xs-12 col-sm-9">
                                                    <p>{$option.call_to_action_text}</p>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    {if $option.additionalInformation}
                                        <div 
                                            id="{$option.id}-additional-information"
                                            class="js-additional-information definition-list col-sm-11 offset-sm-1 wk-payment-info">
                                            {$option.additionalInformation nofilter}
                                        </div>
                                    {/if}
                                    <div id="pay-with-{$option.id}-form" class="js-payment-option-form wk-left" {if Configuration::get('WK_CHECKOUT_DEFAULT_PAYMENT') && (Configuration::get('WK_CHECKOUT_DEFAULT_PAYMENT') == $paymoduleIndex)}{if $option.id == 'payment-option-3'}style="display: block;"{/if}{/if}>
                                            {if $option.form}
                                                {$option.form nofilter}
                                            {else}
                                                <form id="payment-form" method="POST" action="{$option.action nofilter}">
                                                    {foreach from=$option.inputs item=input}
                                                        <input type="{$input.type}" name="{$input.name}" value="{$input.value}">
                                                    {/foreach}
                                                    <button style="display:none" id="pay-with-{$option.id}" type="submit"></button>
                                                </form>
                                            {/if}
                                        </div>
                                    {/foreach}
                                </div>
                            {/foreach}
                        </div>
                    {else}
                        <div class="col-md-12 col-sm-12 col-xs-12">
                            <div class="alert alert-danger">
                                {l s='Unfortunately, there are no payment method available.'  mod='wkonepagecheckout'}
                            </div>
                        </div>
                    {/if}
                {else}
                    <div class="col-md-12 col-sm-12 col-xs-12">
                        <div class="alert alert-danger">
                            {l s='First you need to fill the shipping address.' mod='wkonepagecheckout'}
                        </div>
                    </div>
                {/if}
            </div>
            {* Adriana - 27/04/2020 - início *}
            {* <div id="wkpayment-method"></div> *}
            {* Correção para utilizar o módulo One Page Checkout da Webkul *}
            {* </br><p id="aceitar_termos">.</p> *}
            {* Adriana - 27/04/2020 - fim *}
        </div>
