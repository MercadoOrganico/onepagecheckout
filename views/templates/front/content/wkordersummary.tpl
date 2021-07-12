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

<div id="wk-order-summary-ajax" class="clearfix">
    <article class="wk-box box">
        <div class="wk-heading-img">
            <div class="wk-order-icon wk-sprit wk-left"></div>
            <h4 class="wk-left">{l s='Order Summary' mod='wkonepagecheckout'}</h4>
        </div>

        <div class="col-md-12 col-sm-12 col-xs-12 wk-padding-0">
            {* Adriana - 30/07/2020 - início *}
            {block name='wk_cart_summary'}
                {include file="module:wkonepagecheckout/views/templates/front/content/wkcartsummary.tpl"}
            {/block}
            {* Adriana - 30/07/2020 - fim *}

            {* Adriana - 21/09/2020 - início *}
            {* Vinícius - 07/07/2021 - Início *}
            {* <div class="wk-order-product col-sm-12 col-xs-12">
				<div class="wk-five-row-padding"> *}
            <div class="wk-order-product">
                <div class="">
                    {* Vinícius - 07/07/2021 - Fim *}
                    {if isset($cart.products)}
                        {foreach $cart.products as $product}

                            {* Vinícius - 07/07/2021 - Início *}
                            {* Web product container *}
                            {* <div class="row"> *}
                            <div class="row checkout-product-container-web">
                                {* Vinícius - 07/07/2021 - Fim *}

                                {* Image *}
                                <div class="wk-five-cols">
                                    <div class="wk-five-item">
                                        <div class="wk-five-item-title">
                                            <span>{l s='Image' mod='wkonepagecheckout'}</span>
                                        </div>
                                    </div>
                                    <p class="wkstyle-noborder"></p>

                                    <div class="wk-product-info">
                                        {if isset($product.cover) && $product.cover}
                                            <img class="js-qv-product-cover"
                                                {if Configuration::get('WK_CHECKOUT_PRODUCT_IMAGE') == '1'} width="50" heigth="50"
                                                {else if Configuration::get('WK_CHECKOUT_PRODUCT_IMAGE') == '2'} width="80"
                                                heigth="80" {else if Configuration::get('WK_CHECKOUT_PRODUCT_IMAGE') == '3'}
                                                width="100" heigth="100" {else} width="70" heigth="70" 
                                                {/if}
                                                src="{$product.cover.small.url}">
                                            {* Adriana - 22/03/2021 - início *}
                                            {*<div class="layer hidden-sm-down" data-toggle="modal" data-target="#wk-product-modal-{$product.id_product}">*}
                                            <div class="layer hidden-sm-down" title="{l s='Zoom' mod='wkonepagecheckout'}"
                                                data-toggle="modal" data-target="#wk-product-modal-{$product.id_product}">
                                                {* Adriana - 22/03/2021 - fim *}
                                                <i class="material-icons zoom-in">&#xE8FF;</i>
                                            </div>
                                        {else}
                                            <img {if Configuration::get('WK_CHECKOUT_PRODUCT_IMAGE') == '1'} width="50" heigth="50"
                                                {else if Configuration::get('WK_CHECKOUT_PRODUCT_IMAGE') == '2'} width="80"
                                                heigth="80" {else if Configuration::get('WK_CHECKOUT_PRODUCT_IMAGE') == '3'}
                                                width="100" heigth="100" {else} width="70" heigth="70" 
                                                {/if} class="product-image"
                                                src="{$wk_opc_modules_dir}img/en.jpg" itemprop="image">
                                        {/if}
                                    </div>
                                </div>

                                {* Description *}
                                <div class="wk-five-cols">
                                    <div class="wk-five-item">
                                        <div class="wk-five-item-title">
                                            <span>{l s='Description' mod='wkonepagecheckout'}</span>
                                        </div>
                                    </div>
                                    <p class="wkstyle-noborder"></p>

                                    <div class="wk-product-info">
                                        <div class="js-product-miniature"
                                            data-id-product-attribute="{$product.id_product_attribute}"
                                            data-id-product="{$product.id_product}">
                                            <div>
                                                {*
											<a class="quick-view label" data-link-action="quickview" data-id-product-attribute="{$product.id_product_attribute}" data-id-product="{$product.id_product}" href="javascript:void(0);" title="{l s='Change Combination' mod='wkonepagecheckout'}">
											<span>{$product.name}</span></a>
											*}
                                                <a data-link-action="quickview"
                                                    data-id-product-attribute="{$product.id_product_attribute}"
                                                    data-id-product="{$product.id_product}" href="javascript:void(0);"
                                                    title="{l s='Change Combination' mod='wkonepagecheckout'}">
                                                    <span>{$product.name}</span></a>
                                            </div>
                                            {if isset($product.attributes)}
                                                {foreach $product.attributes as $key => $value}
                                                    <div>
                                                        <span class="wk-attribute">{$key}:</span>
                                                        <span class="wk-attribute-value">{$value}</span>
                                                    </div>
                                                {/foreach}
                                            {/if}

                                            {* Adriana - 21/09/2020 - início *}
                                            {*<div class="wk-product-link"><a target="_blank" href="{$product.url}" >{l s='More Detail' mod='wkonepagecheckout'}</a></div>*}
                                            {* Adriana - 21/09/2020 - fim *}
                                        </div>
                                    </div>
                                </div>

                                {* Quantity *}
                                <div class="wk-five-cols">
                                    <div class="wk-five-item">
                                        <div class="wk-product-info col-md-6 col-sm-6 col-xs-12">
                                            <div class="wk-five-item-title">
                                                <span>{l s='Quantity' mod='wkonepagecheckout'}</span>
                                            </div>
                                            <p class="wkstyle-noborder"></p>

                                            <div>
                                                <div class="bootstrap-touchspin wk-display-flex wk-qty-info">
                                                    <input data-id-product-attribute="{$product.id_product_attribute}"
                                                        data-id-product="{$product.id_product}"
                                                        value="{if isset($product.cart_quantity)}{$product.cart_quantity}{/if}"
                                                        class="wk-hidden-qty form-control" type="hidden" id="wk-cart-hidden-qty"
                                                        min="1" />
                                                    <input data-id-product-attribute="{$product.id_product_attribute}"
                                                        data-id-product="{$product.id_product}"
                                                        value="{if isset($product.cart_quantity)}{$product.cart_quantity}{/if}"
                                                        class="wk-qty form-control" type="text" name="wk-cart-qty" min="1"
                                                        data-id-customization="{if isset($product.id_customization)}{$product.id_customization}{else}0{/if}"
                                                        readonly="readonly" />
                                                    <span class="input-group-btn-vertical">
                                                        <button type="button" class="btn btn-touchspin wk-qty-up">
                                                            <i class="material-icons touchspin-up"></i>
                                                        </button>
                                                        <button type="button"
                                                            class="btn btn-touchspin bootstrap-touchspin-down wk-qty-down">
                                                            <i class="material-icons touchspin-down"></i>
                                                        </button>
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                {* Total *}
                                <div class="wk-five-cols">
                                    <div class="wk-five-item">
                                        <div class="wk-five-item-title">
                                            <span>{l s='Total' mod='wkonepagecheckout'}</span>
                                        </div>
                                        <p class="wkstyle-noborder"></p>

                                        <div>
                                            <span class="product-price">
                                                {if isset($product.total)}
                                                    <span>{$product.total}</span>
                                                {/if}
                                            </span>
                                        </div>
                                    </div>
                                </div>

                                {* Btn Delete *}
                                <div class="wk-five-cols">
                                    <div class="wk-five-item">
                                        <div class="wk-five-item-title">
                                            <span>{l s='Action' mod='wkonepagecheckout'}</span>
                                        </div>
                                        <p class="wkstyle-noborder"></p>

                                        <div>
                                            <div class="cart-line-product-actions">
                                                <a title="{l s='Delete' mod='wkonepagecheckout'}" id="wk-remove-cart"
                                                    data-id-product-attribute="{$product.id_product_attribute}"
                                                    data-id-product="{$product.id_product}" href="javascript:void(0);"
                                                    data-quantity="{$product.cart_quantity}"
                                                    data-id-customization="{if isset($product.id_customization)}{$product.id_customization}{else}0{/if}"
                                                    class="remove-from-cart wk-left">
                                                    <i class="material-icons pull-xs-left">delete</i>
                                                </a>

                                                {if Configuration::get('WK_CHECKOUT_CART_SAVE_LATER') && $customer.is_logged}
                                                    <a title="{l s='Save for later' mod='wkonepagecheckout'}" id="wk-cart-save"
                                                        data-id-product-attribute="{$product.id_product_attribute}"
                                                        data-id-product="{$product.id_product}"
                                                        data-quantity="{$product.cart_quantity}"
                                                        data-id-customization="{if isset($product.id_customization)}{$product.id_customization}{else}0{/if}"
                                                        href="javascript:void(0);" class="remove-from-cart wk-left">
                                                        <i class="material-icons">&#xE8B5;</i>
                                                    </a>
                                                {/if}
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <p></p>
                            </div>

                            {* Vinícius - 07/07/2021 - Início *}
                            {* Mobile product container *}
                            <div class="checkout-product-container-mobile">

                                {* Container 1 *}
                                <div class="checkout-product-content-1 pt-1">

                                    {* Image *}
                                    <div class="pr-1">
                                        {if isset($product.cover) && $product.cover}
                                            <img class="js-qv-product-cover img"
                                                {if Configuration::get('WK_CHECKOUT_PRODUCT_IMAGE') == '1'} width="50" heigth="50"
                                                {else if Configuration::get('WK_CHECKOUT_PRODUCT_IMAGE') == '2'} width="80"
                                                heigth="80" {else if Configuration::get('WK_CHECKOUT_PRODUCT_IMAGE') == '3'}
                                                width="100" heigth="100" {else} width="70" heigth="70" 
                                                {/if}
                                                src="{$product.cover.small.url}">

                                            <div class="layer hidden-sm-down" title="{l s='Zoom' mod='wkonepagecheckout'}"
                                                data-toggle="modal" data-target="#wk-product-modal-{$product.id_product}">

                                                <i class="material-icons zoom-in">&#xE8FF;</i>
                                            </div>
                                        {else}
                                            <img {if Configuration::get('WK_CHECKOUT_PRODUCT_IMAGE') == '1'} width="50" heigth="50"
                                                {else if Configuration::get('WK_CHECKOUT_PRODUCT_IMAGE') == '2'} width="80"
                                                heigth="80" {else if Configuration::get('WK_CHECKOUT_PRODUCT_IMAGE') == '3'}
                                                width="100" heigth="100" {else} width="70" heigth="70" 
                                                {/if} class="product-image"
                                                src="{$wk_opc_modules_dir}img/en.jpg" itemprop="image">
                                        {/if}
                                    </div>

                                    {* Description *}
                                    <div class="js-product-miniature"
                                        data-id-product-attribute="{$product.id_product_attribute}"
                                        data-id-product="{$product.id_product}">
                                        <div>

                                            <a data-link-action="quickview"
                                                data-id-product-attribute="{$product.id_product_attribute}"
                                                data-id-product="{$product.id_product}" href="javascript:void(0);"
                                                title="{l s='Change Combination' mod='wkonepagecheckout'}">
                                                <span>{$product.name}</span></a>
                                        </div>
                                        {if isset($product.attributes)}
                                            {foreach $product.attributes as $key => $value}
                                                <div>
                                                    <span class="wk-attribute">{$key}:</span>
                                                    <span class="wk-attribute-value">{$value}</span>
                                                </div>
                                            {/foreach}
                                        {/if}

                                    </div>

                                </div>

                                {* Container 2 *}
                                <div class="checkout-product-content-2 mt-1">

                                    {* Button Delete *}
                                    <div class="col-xs-4" style="top: 15px; right: 17px;">
                                        <a title="{l s='Delete' mod='wkonepagecheckout'}" id="wk-remove-cart"
                                            data-id-product-attribute="{$product.id_product_attribute}"
                                            data-id-product="{$product.id_product}" href="javascript:void(0);"
                                            data-quantity="{$product.cart_quantity}"
                                            data-id-customization="{if isset($product.id_customization)}{$product.id_customization}{else}0{/if}"
                                            class="remove-from-cart wk-left">
                                            <i class="material-icons pull-xs-left">delete</i>
                                        </a>

                                        {if Configuration::get('WK_CHECKOUT_CART_SAVE_LATER') && $customer.is_logged}
                                            <a title="{l s='Save for later' mod='wkonepagecheckout'}" id="wk-cart-save"
                                                data-id-product-attribute="{$product.id_product_attribute}"
                                                data-id-product="{$product.id_product}" data-quantity="{$product.cart_quantity}"
                                                data-id-customization="{if isset($product.id_customization)}{$product.id_customization}{else}0{/if}"
                                                href="javascript:void(0);" class="remove-from-cart wk-left">
                                                <i class="material-icons">&#xE8B5;</i>
                                            </a>
                                        {/if}
                                    </div>

                                    {* Qauntity *}
                                    <div class="col-xs-4">
                                        <div class="wk-five-item-title">
                                            <span>{l s='Quantity' mod='wkonepagecheckout'}</span>
                                        </div>
                                        <p class="wkstyle-noborder"></p>

                                        <div class="bootstrap-touchspin wk-display-column wk-qty-info">

                                            <input data-id-product-attribute="{$product.id_product_attribute}"
                                                data-id-product="{$product.id_product}"
                                                value="{if isset($product.cart_quantity)}{$product.cart_quantity}{/if}"
                                                class="wk-hidden-qty form-control" type="hidden" id="wk-cart-hidden-qty"
                                                min="1" />

                                            <input data-id-product-attribute="{$product.id_product_attribute}"
                                                data-id-product="{$product.id_product}"
                                                value="{if isset($product.cart_quantity)}{$product.cart_quantity}{/if}"
                                                class="wk-qty form-control" type="text" name="wk-cart-qty" min="1"
                                                data-id-customization="{if isset($product.id_customization)}{$product.id_customization}{else}0{/if}"
                                                readonly="readonly" />

                                            <span class="input-group-btn-vertical mobile-flex-column">

                                                <button type="button" class="btn btn-touchspin wk-qty-up">
                                                    <i class="material-icons touchspin-up"></i>
                                                </button>

                                                <button type="button"
                                                    class="btn btn-touchspin bootstrap-touchspin-down wk-qty-down">
                                                    <i class="material-icons touchspin-down"></i>
                                                </button>

                                            </span>
                                        </div>
                                    </div>

                                    <div class="col-xs-1">
                                    </div>

                                    {* Total *}
                                    <div class="col-xs-2">
                                        <div class="wk-five-item-title">
                                            <span>{l s='Total' mod='wkonepagecheckout'}</span>
                                        </div>
                                        <p class="wkstyle-noborder"></p>

                                        <div>
                                            <span class="product-price">
                                                {if isset($product.total)}
                                                    <span>{$product.total}</span>
                                                {/if}
                                            </span>
                                        </div>
                                    </div>

                                    <div class="col-xs-1">
                                    </div>

                                </div>

                                {* Total *}
                                <div class="col-xs-12">
                                    <hr>
                                </div>
                                {* Vinícius - 07/07/2021 - Fim *}
                            </div>
                            {block name='product_images_modal'}
                                {include file='module:wkonepagecheckout/views/templates/front/content/_partials/wk-product-image-modal.tpl'}
                            {/block}
                        {/foreach}
                    {/if}
                </div>
            </div>
            {* Adriana - 21/09/2020 - fim *}
            <div class="wkhide wkerrorcolor wkorder_error"></div>
        </div>
        <p class="wkstyle"></p>
        {block name='wk-order-total'}
            {include file='module:wkonepagecheckout/views/templates/front/content/_partials/wk_order_total.tpl'}
        {/block}
        <div id="wkorder-summary"></div>
    </article>
    <p class="wkstyle"></p>
</div>