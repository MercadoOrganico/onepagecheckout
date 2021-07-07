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

{* Vinícius - 07/07/2021 - Início *}
<style>
    @media (max-width: 576px) {
        .wk-shipping-carriers {
            width: 100%;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            align-items: center;
            text-align: center;
        }
    }
</style>
{* Vinícius - 07/07/2021 - Fim *}

<div class="wk-shipping-carriers">
    <div class="wk-heading-img">
        <div class="wk-shipping-icon wk-sprit wk-left"></div>
        <h4 class="wk-left">{l s='Shipping Method' mod='wkonepagecheckout'}</h4>
        <div class="wkerrorcolor wkhide wk-left" id="wkshipping-error" style="margin-left:25px;"></div>
    </div>
    {* comentado para alterar o momento de valida��o do zipcode *}
    <div id="hook-display-before-carrier">
        {hook h='displayBeforeCarrier'}
    </div>
    {if $wk_is_logged == 1}
        {if isset($delivery_options) && $delivery_options}
            {foreach from=$delivery_options item=carrier key=carrier_id}
                <div class="row">
                    <div class="wk-shipping-list col-md-12 col-sm-12 col-xs-12">
                        <div class="wk-shipping col-xs-1 col-sm-1 col-md-1 wkpadding">
                            <span class="custom-radio">
                                <input {if $delivery_option == $carrier_id} checked{/if} type="radio"
                                    name="delivery_option[{$id_address}]" id="delivery_option_{$carrier.id}"
                                    class="form-control wk_selected_shipping" wk-opc-id-carrier="{$carrier.id}"
                                    value="{$carrier.id},">
                                <span></span>
                            </span>
                        </div>
                        <div
                            class="wk-shipping-info wk-selected-shipping-{$carrier.id} col-md-11 col-sm-9 col-xs-9 {if $delivery_option == $carrier_id} wkSelectedBorder{/if}">
                            <div class="row">
                                {if Configuration::get('WK_CHECKOUT_CARRIER_LOGO')}
                                    <div class="col-md-3 col-xs-12 col-sm-3">
                                        {if isset($carrier.logo) && $carrier.logo}
                                            <img class="wk-custom-shipping-icon" width="50" src="{$carrier.logo}">
                                        {else}
                                            <img class="wk-custom-shipping-icon" width="50"
                                                src="{$wk_opc_modules_dir}img/carrier-default.jpg">
                                        {/if}
                                    </div>
                                {/if}
                                <div class="col-md-6 col-xs-12 col-sm-6">
                                    <span class="carrier-name">{$carrier.name}</span>
                                    <br>
                                    {if Configuration::get('WK_CHECKOUT_CARRIER_DESC')}
                                        {if isset($carrier.delay)}<span class="carrier-delay">{$carrier.delay}</span>{/if}
                                    {/if}
                                </div>
                                <div class="col-md-3 col-xs-12 col-sm-3">
                                    <span class="carrier-price">{$carrier.price}</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row carrier-extra-content">
                    {$carrier.extraContent nofilter}
                </div>
            {/foreach}
            <div id="delivery">
                <p for="delivery_message">
                    {l s='If you would like to add a comment about your order, please write it in the field below.' mod='wkonepagecheckout'}
                </p>
                <textarea rows="3" cols="50" id="delivery_message" name="delivery_message">{$delivery_message}</textarea>
            </div>
        {else}
            <div class="col-md-12 col-sm-12 col-xs-12">
                <div class="alert alert-danger">
                    {l s='Unfortunately, there are no carriers available for your delivery address.' mod='wkonepagecheckout'}
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

    <div id="hook-display-after-carrier">
        {$hookDisplayAfterCarrier nofilter}
        {hook h='displayAfterCarrier'}
    </div>

    <div id="extra_carrier "></div>

    <div id="wkshipping-method"></div>
</div>
<div class="wkpayment-checkout"></div>