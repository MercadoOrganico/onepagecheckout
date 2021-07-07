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

{extends file='checkout/checkout.tpl'}
{block name='content'}

    <section class="main" id="wk-one-page-checkout">
    {* Vinícius - 07/07/2021 - Início *}
    {* <section class="page-content card card-block"> *}
    <section class="">
    {* Vinícius - 07/07/2021 - Fim *}
            <div class="row">
                {* Adriana - 04/10/2020 - início *}
                {*<div class="col-lg-4 col-md-12 col-sm-12 wk-checkout-left-column">*}
                {* Vinícius - 07/07/2021 - Início *}
                {* <div class="col-lg-5 col-md-12 col-sm-12 wk-checkout-left-column"> *}
                <div class="col-lg-5 col-md-12">
                {* Vinícius - 07/07/2021 - Início *}
                    {* Adriana - 04/10/2020 - fim *}
                    {block name='wk-customer-info'}
                        {include file="module:wkonepagecheckout/views/templates/front/content/wk_customer_info.tpl"}
                    {/block}
                </div>
                {* Adriana - 04/10/2020 - início *}
                {*<div class="col-lg-8 col-md-12 col-sm-12 wk-padding-0">*}
                {* Adriana - 03/11/2020 - início *}
                {*<div class="col-lg-7 col-md-12 col-sm-12 wk-padding-0">*}
                <div class="col-lg-7 col-md-12 col-sm-12 col-xs-12 wk-checkout-left-column">
                    {* Adriana - 03/11/2020 - fim *}
                    {* Adriana - 04/10/2020 - fim *}
                    {block name='wk_order_summary'}
                        {include file="module:wkonepagecheckout/views/templates/front/content/wkordersummary.tpl"}
                    {/block}

                    {block name='wk_order_shipping'}
                        <div class="col-md-6 col-sm-12 col-xs-12" id="wk_shipping_section">
                            {include file="module:wkonepagecheckout/views/templates/front/content/wkshippingmethod.tpl"}
                        </div>
                    {/block}

                    {block name='wk_order_payment'}
                        <div class="col-md-6 col-sm-12 col-xs-12" id="wk_payment_section">
                            {include file="module:wkonepagecheckout/views/templates/front/content/wkpaymentmethod.tpl"}
                        </div>
                    {/block}
                    {* Adriana - 27/07/2020 - início *}
                </div>

                <div class="col-md-4">
                </div>

                <div class="col-md-6">
                    {block name='wk_payment_condition'}
                        {include file="module:wkonepagecheckout/views/templates/front/content/wkcondition.tpl"}
                    {/block}
                </div>
                <div class="col-md-2">
                    {* Adriana - 27/07/2020 - fim *}
                </div>
            </div>
        </section>
        {if Configuration::get('WK_CHECKOUT_CART_ALSO_BOUGHT')}
            {hook h="displayWhoBoughtAlsoBought"}
        {/if}
    </section>
{/block}
