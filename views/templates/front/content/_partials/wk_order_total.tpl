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

<div class="wk-order-total col-md-12 col-sm-12">
    <div class="row">
        <div class="wk-two-row-padding">

            {* Button add Voucher *}
            <div>

                <div class="wk-two-cols">
                    <input placeholder="{l s='Promo code' mod='wkonepagecheckout'}" type="text" name="wk-voucher"
                        id="wk-voucher" class="form-control">
                    <button id="addVoucher" class="btn btn-primary">{l s='Add' mod='wkonepagecheckout'}</button>
                </div>

                <div class="wkhide col-md-8 col-xs-12 wkpromo-code alert alert-danger" role="alert">
                    <i class="material-icons"></i><span>{l s='Enter a voucher code.' mod='wkonepagecheckout'}</span>
                </div>

            </div>

            {* Details container *}
            <div>

                {if isset($cart.vouchers.added)}
                    {foreach $cart.vouchers.added as $voucher}
                        <div class="wk-box">
                            <div class="wk-product-info col-md-7 col-sm-7 col-xs-7">
                                <span>{$voucher.name}</span>
                            </div>
                            <div class="col-md-3 col-sm-3 col-xs-3">
                                <span>({$voucher.reduction_formatted})</span>
                            </div>
                            <div title="{l s='Delete voucher' mod='wkonepagecheckout'}"
                                class="wk-product-info col-md-1 col-sm-2 col-xs-2" id="wk-delete-voucher"
                                data-id="{$voucher.id_cart_rule}">
                                <i class="material-icons pull-xs-left">delete</i>
                            </div>
                        </div>
                    {/foreach}
                {/if}

                {* Vinícius - 07/07/2021 - Início *}
                {* <div class="wk-two-cols"> *}
                <div class="">
                {* Vinícius - 07/07/2021 - Fim *}
                    <div class="wk-box">
                        <div class="wk-product-info col-md-8 col-sm-6 col-xs-6">
                            <span>{l s='Total Products (tax incl.)' mod='wkonepagecheckout'}</span>
                        </div>
                        <div class="col-md-4 col-xs-2 col-sm-2 col-sm-6 wk-product-val">
                            {if isset($cart.subtotals.products)}
                                <span>{$cart.subtotals.products.value}</span>
                            {/if}
                        </div>
                    </div>
                    <div class="wk-box">
                        <div class="wk-product-info col-md-8 col-sm-6 col-xs-6">
                            <span>{l s='Total shipping' mod='wkonepagecheckout'}</span>
                        </div>
                        <div class="col-md-4 col-xs-2 col-sm-6 col-xs-6 wk-product-val">
                            {if isset($cart.subtotals.shipping)}
                                <span>{$cart.subtotals.shipping.value}</span>
                            {/if}
                        </div>
                    </div>
                    {if isset($cart.subtotals.discounts)}
                        <div class="wk-box">
                            <div class="wk-product-info col-md-8 col-sm-6 col-xs-6">
                                <span>{l s='Total Discount' mod='wkonepagecheckout'}</span>
                            </div>
                            <div class="col-md-4 col-xs-2 col-sm-6 col-xs-6 wk-product-val">
                                <span>{$cart.subtotals.discounts.value}</span>
                            </div>
                        </div>
                    {/if}
                    {if Configuration::get('PS_TAX_DISPLAY')}
                        <div class="wk-box">
                            <div class="wk-product-info col-md-8 col-sm-6 col-xs-6">
                                <span>{l s='Total tax' mod='wkonepagecheckout'}</span>
                            </div>
                            <div class="col-md-4 col-xs-2 col-sm-6 col-xs-6 wk-product-val">
                                {if isset($cart.subtotals.tax)}
                                    <span>{$cart.subtotals.tax.value}</span>
                                {else}
                                    <span>--</span>
                                {/if}
                            </div>
                        </div>
                    {/if}

                    {* Vinícius - 07/07/2021 - Início *}
                    {* <div class="wk-box"> *}
                    <div class="wk-box price-color-column">
                    {* Vinícius - 07/07/2021 - Fim *}
                        <div class="wk-product-info col-md-8 col-sm-6 col-xs-6">
                            <span>{l s='Total' mod='wkonepagecheckout'}</span>
                        </div>
                        <div class="col-md-4 col-xs-2 col-sm-6 col-xs-6 wk-product-val">
                            {if isset($cart.totals.total)}
                                <span>{$cart.totals.total.value}</span>
                            {/if}
                        </div>
                        <div class="wk-product-info col-md-12 col-sm-6 col-xs-6">
                            {foreach from=$cart.subtotals item="subtotal"}
                                {if $subtotal.type == 'shippingRangeSup'}
                                    <p style="margin-top:10px; color: #ce1337;font-size: 18px;font-weight: bold;">
                                        {$subtotal.label}</p>
                                    <a class="btn btn-primary" style='margin-top: 10px;' href="https://mercadoorganico.com/"> <i
                                            class="material-icons">chevron_left</i>Continue comprando </a>
                                {else}
                                    <span class="label">{''}</span>
                                {/if}
                            {/foreach}
                        </div>
                    </div>

                </div>

            </div>
        </div>
    </div>
</div>

<div class="wk-order-total col-md-12 col-sm-12">
    <div class="row">
        <div class="col-md-12 col-xs-8 col-sm-8">
            {if isset($cart.discounts) && $cart.discounts}
                <div class="wk-voucher-available col-md-12">
                    <p class="block-promo promo-highlighted">
                        {l s='Take advantage of our exclusive offers: ' mod='wkonepagecheckout'}</p>
                    <ul class="block-promo">
                        {foreach $cart.discounts as $discounts}
                            <li>
                            
                                <a id="wkadd-code" href="javascript:void(0);">
                                    <span class="wkcode">{$discounts.code} - {$discounts.name} </span>
                                </a>

                            </li>
                        {/foreach}
                    </ul>
                </div>
            {/if}

        </div>
    </div>
</div>
