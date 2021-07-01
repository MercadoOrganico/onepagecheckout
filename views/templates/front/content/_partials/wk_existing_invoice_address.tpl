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

{if isset($customer.addresses) && $customer.addresses|count > 0}

    <div class="form-group clearfix wk-align-center">
        <label class="col-md-1 col-xs-1 col-sm-1">
            <span class="custom-radio">
                <input type="radio" name="wk-invoice-address" value="1" checked="checked">
                <span></span>
            </span>
        </label>
        <div class="col-md-10 col-sm-10 col-xs-10">
            <select class="form-control" id="wk-existing-invoice-address">
                {foreach $customer.addresses as $addr} 
                {$addr|@print_r}               
                    <option
                        {if isset($cart.id_address_delivery)}
                            {if $cart.id_address_invoice == $addr.id}selected="selected"{/if}
                        {/if}
                        value="{$addr.id}">{$addr.address1}</option>
                {/foreach}
            </select>
        </div>
    </div>
{/if}

{if $customer.addresses|count > 0}
    <div class="form-group clearfix">
        <label class="col-md-1 col-xs-1 col-sm-1"></label>
        <div class="col-md-10 col-sm-10 col-xs-10">
            <address class="wk-diff-address wk-invoice-address-card">{$customer.addresses.{$cart.id_address_invoice}.formatted nofilter}</address>
        </div>
    </div>
{/if}

{if $customer.addresses|count > 0}
<div class="form-group clearfix wk-align-center">
    <label class="col-md-1 col-xs-1 col-sm-1">
        <span class="custom-radio">
            <input type="radio" name="wk-invoice-address" value="2">
            <span></span>
        </span>
    </label>
    <div class="col-md-10 col-sm-10 col-xs-10">
        <div class="wk-diff-address">{l s='Add new invoice address' mod='wkonepagecheckout'}</div>
    </div>
</div>
{/if}
