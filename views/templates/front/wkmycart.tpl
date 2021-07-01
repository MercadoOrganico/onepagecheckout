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

{extends file=$layout}
{block name='content'}
<section id="main">
{if isset($smarty.get.success)}
	<p class="alert alert-success">
		<button data-dismiss="alert" class="close" type="button">×</button>
		{l s='Deleted Successfully' mod='wkonepagecheckout'}
	</p>
{/if}
	<header class="page-header">
		<h1>{l s='My Saved Cart' mod='wkonepagecheckout'}</h1>
    </header>

	<section class="page-content card card-block" id="content">
		<table class="table table-bordered">
			<thead>
				<tr>
					<th>{l s='Product Name' mod='wkonepagecheckout'}</th>
					<th>{l s='Product Attribute' mod='wkonepagecheckout'}</th>
					<th>
                        {l s='Unit price' mod='wkonepagecheckout'}<br>
                        {if isset($showTax)}
                            {l s='(tax incl.)' mod='wkonepagecheckout'}
                        {else}
                            {l s='(tax excl.)' mod='wkonepagecheckout'}
                        {/if}
                    </th>
                    <th>{l s='Qty' mod='wkonepagecheckout'}</th>
                    <th>{l s='In Stock' mod='wkonepagecheckout'}</th>
                    <th>{l s='Date' mod='wkonepagecheckout'}</th>
					<th>{l s='Action' mod='wkonepagecheckout'}</th>
				</tr>
			</thead>
			<tbody>
            {if isset($savedCart)}
                {foreach $savedCart as $key => $cart}
                    <tr>
                        <td><a style="margin-right:10px;" title="{l s='View Product' mod='wkonepagecheckout'}" href="{if isset($cart.product_link)}{$cart.product_link}{/if}">{$cart.product_name}</a></td>
                        <td>{if isset($cart.attribute_name)}{$cart.attribute_name}{else}{l s='Default' mod='wkonepagecheckout'}{/if}</td>
                        <td style="text-align:center;">{if $cart.product_price}{$cart.product_price}{else}--{/if}</td>
                        <td style="text-align:center;">{$cart.quantity}</td>
                        <td style="text-align:center;">{$cart.available_qty}</td>
                        <td>{$cart.date_add|date_format:"%A, %e %B, %Y"}</td>
                        <td>
                            {*<a style="margin-right:10px;" title="{l s='View Product' mod='wkonepagecheckout'}" href="{if isset($cart.product_link)}{$cart.product_link}{/if}">
                                <i class="material-icons">&#xE417;</i>
                            </a>*}
                            {if $cart.available_for_order > 0}
                            <a
                                title="{l s='Add to cart' mod='wkonepagecheckout'}"
                                href="javascript:void(0);"
                                id="wk-add-into-cart"
                                data-quantity="{$cart.quantity}"
                                data-id-product="{$cart.id_product}"
                                data-id-product-attribute="{$cart.id_product_attribute}">
                                <i class="material-icons">&#xE8B3;</i>
                            </a>
                            {/if}
                            <img style="display:none;" id="wk-cart-loader-{$cart.id_product}-{$cart.id_product_attribute}" src="{$modules_dir}wkonepagecheckout/views/img/p_loading.gif" width="20" />
                            <a
                                title="{l s='Delete' mod='wkonepagecheckout'}"
                                href="{$wksavecart}&id={$cart.id}"
                                id="wk-delete-cart"
                                data-id-product="{$cart.id_product}"
                                data-id-product-attribute="{$cart.id_product_attribute}">
                                <i class="material-icons">&#xE872;</i>
                            </a>
                        </td>
                    </tr>
                {/foreach}
            {/if}
			</tbody>
		</table>
        {if !isset($savedCart)}
            <p>{l s='No product found!' mod='wkonepagecheckout'}</p>
        {/if}
	</section>
</section>
{/block}
