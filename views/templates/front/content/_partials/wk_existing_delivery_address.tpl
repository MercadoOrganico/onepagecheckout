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

<div class="form-group clearfix">
    <div class="col-md-12">
        <span class="custom-checkbox">
            <label>
                <input type="checkbox" name="wk-different-invoice" value="1" class="form-control" {if Configuration::get('WK_CHECKOUT_DELIVERY_AS_INVOICE')}checked="checked"{/if}>
                <span><i class="material-icons rtl-no-flip checkbox-checked"></i></span>
                <span>{l s='Use this address as invoice address' mod='wkonepagecheckout'}</span>
            </label>
        </span>
    </div>
</div>
{if isset($customer.addresses) && $customer.addresses|count > 0}
    <div class="form-group clearfix wk-align-center">
        <label class="col-md-1 col-sm-1 col-xs-1">
            <span class="custom-radio">
                <input type="radio" name="wk-delivery-address" value="1" checked="checked">
                <span></span>
            </span>
        </label>
        <div class="col-md-10 col-sm-10 col-xs-10">
            <select class="form-control" id="wk-existing-delivery-address">
                {foreach $customer.addresses as $addr}
                    <option
                        {if isset($cart.id_address_delivery)}
                            {if $cart.id_address_delivery == $addr.id}selected="selected"{/if}
                        {/if}
                        value="{$addr.id}">{$addr.address1}</option>
                {/foreach}
            </select>
        </div>
    </div>
{/if}

{if $customer.addresses|count > 0}
    <div class="form-group wk-delivery-address-div clearfix">
        <label class="col-md-1 col-sm-1 col-xs-1"></label>
        <div class="col-md-10 col-sm-10 col-xs-10">
            <address class="wk-diff-address wk-delivery-address-card">{$customer.addresses.{$cart.id_address_delivery}.formatted nofilter}</address>
        </div>
    </div>
{/if}

{if $customer.addresses|count > 0}
<div class="form-group clearfix wk-align-center">
    <label class="col-md-1 col-sm-1 col-xs-1">
        <span class="custom-radio">
            <input type="radio" name="wk-delivery-address" value="2" data-attr="delivery" >
            <span></span>
        </span>
    </label>
    <div class="col-md-10 col-sm-10 col-xs-10">
        <div class="wk-diff-address">{l s='Add new delivery address' mod='wkonepagecheckout'}</div>
    </div>
</div>
{/if}
