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

<div class="form-group">
    <label class="label-control required">{l s='State' mod='wkonepagecheckout'}</label>
    <select name="wk_invoice_address_state" class="form-control wk_address_state" data-attr="invoice" id="id_state">
        <option value disabled selected>{l s='-- please choose --' d='Shop.Forms.Labels'}</option>
  
        {foreach $states as $state}
            <option
                {if isset($delivery_address)}
                    {if $delivery_address->id_state == $state.id_state}selected="selected"{/if}
                {else if isset($cartAddress)}
                    {if $cartAddress->id_state == $state.id_state}selected="selected"{/if}
                {/if}
                value="{$state.id_state}">
                {$state.name}
            </option>
        {/foreach}

    </select>

	<span class="help-block wk-error wk_invoice_address_state"></span>
</div>
