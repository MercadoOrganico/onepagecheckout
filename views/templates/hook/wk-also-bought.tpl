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

<div class="wk-products">
    {if isset($products)}
        <section class="page-content card card-block featured-products clearfix m-t-3" id="products">
            <h2>{l s='Customers who bought this product also bought:' mod='wkonepagecheckout'}</h2>
            <div class="products">
                {foreach from=$products item="product"}
                    {include file="module:wkonepagecheckout/views/templates/hook/wk-product.tpl" product=$product}
                {/foreach}
            </div>
        </section>
    {/if}
</div>
