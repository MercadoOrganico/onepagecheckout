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

{extends file='catalog/_partials/miniatures/product.tpl'}
{*
{block name='product_miniature_item'}
    <article class="product-miniature js-product-miniature" data-id-product="{$product.id_product}" data-id-product-attribute="{$product.id_product_attribute}" itemscope itemtype="http://schema.org/Product">
        <div class="thumbnail-container">
            {block name='product_thumbnail'}
            <a href="{$product.url}" class="thumbnail product-thumbnail">
                <img
                    src = "{$product.cover.bySize.home_default.url}"
                    alt = "{$product.cover.legend}"
                    data-full-size-image-url = "{$product.cover.large.url}">
            </a>
            {/block}

            <div class="product-description">
                {block name='product_name'}
                    <h1 class="h3 product-title" itemprop="name"><a href="{$product.url}">{$product.name|truncate:30:'...'}</a></h1>
                {/block}

                {block name='product_price_and_shipping'}
                    {if $product.show_price}
                        <div class="product-price-and-shipping">
                            {if $product.has_discount}
                                {hook h='displayProductPriceBlock' product=$product type="old_price"}
                                <span class="regular-price">{$product.regular_price}</span>
                                {if $product.discount_type === 'percentage'}
                                    <span class="discount-percentage">{$product.discount_percentage}</span>
                                {/if}
                            {/if}
                            {hook h='displayProductPriceBlock' product=$product type="before_price"}
                            <span itemprop="price" class="price">{$product.price}</span>
                            {hook h='displayProductPriceBlock' product=$product type='unit_price'}
                            {hook h='displayProductPriceBlock' product=$product type='weight'}
                            <div class="">
                                <button
                                    data-id-product="{$product.id_product}"
                                    data-id-product-attribute="{$product.id_product_attribute}"
                                    type="submit"
                                    data-button-action="wk-add-to-cart"
                                    class="btn btn-primary add-to-cart">
                                    <i class="material-icons shopping-cart"></i>{l s='Add to cart' mod='wkonepagecheckout'}
                                </button>
                            </div>
                        </div>
                    {/if}
                {/block}

                {block name='product_reviews'}
                    {hook h='displayProductListReviews' product=$product}
                {/block}
            </div>

            {block name='product_flags'}
                <ul class="product-flags">
                    {foreach from=$product.flags item=flag}
                        <li class="{$flag.type}">{$flag.label}</li>
                    {/foreach}
                </ul>
            {/block}

            <div class="highlighted-informations{if !$product.main_variants} no-variants{/if} hidden-sm-down">
            {block name='quick_view'}
                <a class="quick-view" href="#" data-link-action="quickview">
                    <i class="material-icons search">&#xE8B6;</i> {l s='Quick view' mod='wkonepagecheckout'}
                </a>
            {/block}

            {block name='product_variants'}
                {if $product.main_variants}
                    {include file='catalog/_partials/variant-links.tpl' variants=$product.main_variants}
                {/if}
            {/block}
        </div>
    </article>
{/block} *}
