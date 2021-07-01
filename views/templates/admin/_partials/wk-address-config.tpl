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

<div class="row">
    <div class="col-sm-5 panel" style="width:48%;">
        <div class="panel-heading">
            <p>{l s='Delivery Address' mod='wkonepagecheckout'}</p>
        </div>
        <div class="panel-body">
            <form action="{$currentIndex}" class="defaultForm form-horizontal" method="post" enctype="multipart/form-data">
                <div class="form-wrapper">
                    <div class="form-group">
                        <label class="control-label col-lg-5">
                            <span title="" data-html="true" data-toggle="tooltip" class="label-tooltip" data-original-title="{l s='If Yes, then the invoice address will be same as delivery address' mod='wkonepagecheckout'}">{l s='Set delivery address as invoice address : ' mod='wkonepagecheckout'}</span>
                        </label>
                        <div class="col-lg-6 col-md-offset-1">
                            <span class="switch prestashop-switch fixed-width-lg">
                                <input type="radio" name="wk_checkout_delivery_as_invoice" id="wk_checkout_delivery_as_invoice_on" value="1"
                                {if isset($smarty.post.wk_checkout_delivery_as_invoice) && $smarty.post.wk_checkout_delivery_as_invoice == 1}checked="checked"
                                {else if isset($configValues) && $configValues.WK_CHECKOUT_DELIVERY_AS_INVOICE == 1}checked="checked"
                                {else if !isset($smarty.post.wk_checkout_delivery_as_invoice)}checked="checked"{/if}>
                                <label for="wk_checkout_delivery_as_invoice_on">{l s='Yes' mod='wkonepagecheckout'}</label>
                                {if isset($configValues)}
                                <input type="radio" name="wk_checkout_delivery_as_invoice" id="wk_checkout_delivery_as_invoice_off" value="0" {if $configValues.WK_CHECKOUT_DELIVERY_AS_INVOICE == '0'}checked="checked"{else if isset($smarty.post.wk_checkout_guest_allow) && $smarty.post.wk_checkout_delivery_as_invoice == '0'}checked="checked"{/if}>
                                {else}
                                <input type="radio" name="wk_checkout_delivery_as_invoice" id="wk_checkout_delivery_as_invoice_off" value="0" {if isset($smarty.post.wk_checkout_delivery_as_invoice) && $smarty.post.wk_checkout_delivery_as_invoice == '0'}checked="checked"{/if}>
                                {/if}
                                <label for="wk_checkout_delivery_as_invoice_off">{l s='No' mod='wkonepagecheckout'}</label>
                                <a class="slide-button btn"></a>
                            </span>
                            <div class="help-block">{l s='Use delivery address as invoice address' mod='wkonepagecheckout'}</div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-lg-5">
                            <span title="" data-html="true" data-toggle="tooltip" class="label-tooltip" data-original-title="{l s='Show company input field for delivery address' mod='wkonepagecheckout'}">{l s='Company : ' mod='wkonepagecheckout'}</span>
                        </label>
                        <div class="col-lg-6 col-md-offset-1 checkbox">
                            <label class="custom_checkbox">
                                <input
                                    {if $configValues.WK_CHECKOUT_DELIVERY_COMPANY_SHOW == '1'}checked="checked"{/if}
                                    data-required="0"
                                    data-field-value="wk_checkout_delivery_company_req"
                                    class="wk_delivery_req_field"
                                    type="checkbox"
                                    value="1"
                                    name="wk_checkout_delivery_company_show"
                                    id="wk_checkout_delivery_company_show">
                                <span>{l s='Show' mod='wkonepagecheckout'}</span>
                            </label>
                            <label class="custom_checkbox">
                                <input
                                    {if $configValues.WK_CHECKOUT_DELIVERY_COMPANY_REQ == '1'}checked="checked"{/if}
                                    data-required="1"
                                    data-field-value="wk_checkout_delivery_company_show"
                                    class="wk_delivery_req_field"
                                    type="checkbox"
                                    value="2"
                                    name="wk_checkout_delivery_company_req"
                                    id="wk_checkout_delivery_company_req">
                                <span>{l s='Required' mod='wkonepagecheckout'}</span>
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-lg-5">
                            <span title="" data-html="true" data-toggle="tooltip" class="label-tooltip" data-original-title="{l s='Show DNI number input field for delivery address' mod='wkonepagecheckout'}">{l s='DNI Number : ' mod='wkonepagecheckout'}</span>
                        </label>
                        <div class="col-lg-6 col-md-offset-1 checkbox">
                            <label class="custom_checkbox">
                                <input
                                    {if $configValues.WK_CHECKOUT_DELIVERY_DNI_SHOW == '1'}checked="checked"{/if}
                                    data-required="0"
                                    data-field-value="wk_checkout_delivery_dni_req"
                                    class="wk_delivery_req_field"
                                    type="checkbox"
                                    value="1"
                                    name="wk_checkout_delivery_dni_show"
                                    id="wk_checkout_delivery_dni_show">
                                <span>{l s='Show' mod='wkonepagecheckout'}</span>
                            </label>
                            <label class="custom_checkbox">
                                <input
                                    {if $configValues.WK_CHECKOUT_DELIVERY_DNI_REQ == '1'}checked="checked"{/if}
                                    data-required="1"
                                    data-field-value="wk_checkout_delivery_dni_show"
                                    class="wk_delivery_req_field"
                                    type="checkbox"
                                    value="2"
                                    name="wk_checkout_delivery_dni_req"
                                    id="wk_checkout_delivery_dni_req">
                                <span>{l s='Required' mod='wkonepagecheckout'}</span>
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-lg-5">
                            <span title="" data-html="true" data-toggle="tooltip" class="label-tooltip" data-original-title="{l s='Show address alias input field for delivery address' mod='wkonepagecheckout'}">{l s='Number : ' mod='wkonepagecheckout'}</span>
                        </label>
                        <div class="col-lg-6 col-md-offset-1 checkbox">
                            <label class="custom_checkbox">
                                <input
                                    {if $configValues.WK_CHECKOUT_DELIVERY_NUMBER_SHOW == '1'}checked="checked"{/if}
                                    data-required="0"
                                    data-field-value="wk_checkout_delivery_number_req"
                                    class="wk_delivery_req_field"
                                    type="checkbox"
                                    value="1"
                                    name="wk_checkout_delivery_number_show"
                                    id="wk_checkout_delivery_number_show">
                                <span>{l s='Show' mod='wkonepagecheckout'}</span>
                            </label>
                            <label class="custom_checkbox">
                                <input
                                    {if $configValues.WK_CHECKOUT_DELIVERY_NUMBER_REQ == '1'}checked="checked"{/if}
                                    data-required="1"
                                    data-field-value="wk_checkout_delivery_number_show"
                                    class="wk_delivery_req_field"
                                    type="checkbox"
                                    value="2"
                                    name="wk_checkout_delivery_number_req"
                                    id="wk_checkout_delivery_number_req">
                                <span>{l s='Required' mod='wkonepagecheckout'}</span>
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-lg-5">
                            <span title="" data-html="true" data-toggle="tooltip" class="label-tooltip" data-original-title="{l s='Show other information input field for delivery address' mod='wkonepagecheckout'}">{l s='Other Information : ' mod='wkonepagecheckout'}</span>
                        </label>
                        <div class="col-lg-6 col-md-offset-1 checkbox">
                            <label class="custom_checkbox">
                                <input
                                    {if $configValues.WK_CHECKOUT_DELIVERY_OTHER_SHOW == '1'}checked="checked"{/if}
                                    data-required="0"
                                    data-field-value="wk_checkout_delivery_other_req"
                                    class="wk_delivery_req_field"
                                    type="checkbox"
                                    value="1"
                                    name="wk_checkout_delivery_other_show"
                                    id="wk_checkout_delivery_other_show">
                                <span>{l s='Show' mod='wkonepagecheckout'}</span>
                            </label>
                            <label class="custom_checkbox">
                                <input
                                    {if $configValues.WK_CHECKOUT_DELIVERY_OTHER_REQ == '1'}checked="checked"{/if}
                                    data-required="1"
                                    data-field-value="wk_checkout_delivery_other_show"
                                    class="wk_delivery_req_field"
                                    type="checkbox"
                                    value="2"
                                    name="wk_checkout_delivery_other_req"
                                    id="wk_checkout_delivery_other_req">
                                <span>{l s='Required' mod='wkonepagecheckout'}</span>
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-lg-5">
                            <span title="" data-html="true" data-toggle="tooltip" class="label-tooltip" data-original-title="{l s='Show address complement input field for delivery address' mod='wkonepagecheckout'}">{l s='Address Complement : ' mod='wkonepagecheckout'}</span>
                        </label>
                        <div class="col-lg-6 col-md-offset-1 checkbox">
                            <label class="custom_checkbox">
                                <input
                                    {* Adriana - 15/07/2020 - início *}
                                    {*
                                    {if $configValues.WK_CHECKOUT_DELIVERY_ADDRESS_COMPANY_SHOW == '1'}checked="checked"{/if}
                                    *}
                                    {if $configValues.WK_CHECKOUT_DELIVERY_ADDRESS_COMPLEM_SHOW == '1'}checked="checked"{/if}
                                    {* Adriana - 15/07/2020 - fim *}
                                    data-required="0"
                                    data-field-value="wk_checkout_delivery_add_comp_req"
                                    class="wk_delivery_req_field"
                                    type="checkbox"
                                    value="1"
                                    name="wk_checkout_delivery_add_comp_show"
                                    id="wk_checkout_delivery_add_comp_show">
                                <span>{l s='Show' mod='wkonepagecheckout'}</span>
                            </label>
                            <label class="custom_checkbox">
                                <input
                                    {* Adriana - 15/07/2020 - início *}
                                    {*
                                    {if $configValues.WK_CHECKOUT_DELIVERY_ADDRESS_COMPANY_REQ == '1'}checked="checked"{/if}
                                    *}
                                    {if $configValues.WK_CHECKOUT_DELIVERY_ADDRESS_COMPLEM_REQ == '1'}checked="checked"{/if}
                                    {* Adriana - 15/07/2020 - fim *}
                                    data-required="1"
                                    data-field-value="wk_checkout_delivery_add_comp_show"
                                    class="wk_delivery_req_field"
                                    type="checkbox"
                                    value="2"
                                    name="wk_checkout_delivery_add_comp_req"
                                    id="wk_checkout_delivery_add_comp_req">
                                <span>{l s='Required' mod='wkonepagecheckout'}</span>
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-lg-5">
                            <span title="" data-html="true" data-toggle="tooltip" class="label-tooltip" data-original-title="{l s='Show mobile phone input field for delivery address' mod='wkonepagecheckout'}">{l s='Mobile Phone : ' mod='wkonepagecheckout'}</span>
                        </label>
                        <div class="col-lg-6 col-md-offset-1 checkbox">
                            <label class="custom_checkbox">
                                <input
                                    {if $configValues.WK_CHECKOUT_DELIVERY_MOBILE_PHONE_SHOW == '1'}checked="checked"{/if}
                                    data-required="0"
                                    data-field-value="wk_checkout_delivery_mobile_phone_req"
                                    class="wk_delivery_req_field"
                                    type="checkbox"
                                    value="1"
                                    name="wk_checkout_delivery_mobile_phone_show"
                                    id="wk_checkout_delivery_mobile_phone_show">
                                <span>{l s='Show' mod='wkonepagecheckout'}</span>
                            </label>
                            <label class="custom_checkbox">
                                <input
                                    {if $configValues.WK_CHECKOUT_DELIVERY_MOBILE_PHONE_REQ == '1'}checked="checked"{/if}
                                    data-required="1"
                                    data-field-value="wk_checkout_delivery_mobile_phone_show"
                                    class="wk_delivery_req_field"
                                    type="checkbox"
                                    value="2"
                                    name="wk_checkout_delivery_mobile_phone_req"
                                    id="wk_checkout_delivery_mobile_phone_req">
                                <span>{l s='Required' mod='wkonepagecheckout'}</span>
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-lg-5">
                            <span title="" data-html="true" data-toggle="tooltip" class="label-tooltip" data-original-title="{l s='Show phone input field for delivery address' mod='wkonepagecheckout'}">{l s='Phone : ' mod='wkonepagecheckout'}</span>
                        </label>
                        <div class="col-lg-6 col-md-offset-1 checkbox">
                            <label class="custom_checkbox">
                                <input
                                    {if $configValues.WK_CHECKOUT_DELIVERY_PHONE_SHOW == '1'}checked="checked"{/if}
                                    data-required="0"
                                    data-field-value="wk_checkout_delivery_phone_req"
                                    class="wk_delivery_req_field"
                                    type="checkbox"
                                    value="1"
                                    name="wk_checkout_delivery_phone_show"
                                    id="wk_checkout_delivery_phone_show">
                                <span>{l s='Show' mod='wkonepagecheckout'}</span>
                            </label>
                            <label class="custom_checkbox">
                                <input
                                    {if $configValues.WK_CHECKOUT_DELIVERY_PHONE_REQ == '1'}checked="checked"{/if}
                                    data-required="1"
                                    data-field-value="wk_checkout_delivery_phone_show"
                                    class="wk_delivery_req_field"
                                    type="checkbox"
                                    value="2"
                                    name="wk_checkout_delivery_phone_req"
                                    id="wk_checkout_delivery_phone_req">
                                <span>{l s='Required' mod='wkonepagecheckout'}</span>
                            </label>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="control-label col-lg-5">
                            <span title="" data-html="true" data-toggle="tooltip" class="label-tooltip" data-original-title="{l s='Show address alias input field for delivery address' mod='wkonepagecheckout'}">{l s='Address Alias : ' mod='wkonepagecheckout'}</span>
                        </label>
                        <div class="col-lg-6 col-md-offset-1 checkbox">
                            <label class="custom_checkbox">
                                <input
                                    {if $configValues.WK_CHECKOUT_DELIVERY_ALIAS_SHOW == '1'}checked="checked"{/if}
                                    data-required="0"
                                    data-field-value="wk_checkout_delivery_alias_req"
                                    class="wk_delivery_req_field"
                                    type="checkbox"
                                    value="1"
                                    name="wk_checkout_delivery_alias_show"
                                    id="wk_checkout_delivery_alias_show">
                                <span>{l s='Show' mod='wkonepagecheckout'}</span>
                            </label>
                            <label class="custom_checkbox">
                                <input
                                    {if $configValues.WK_CHECKOUT_DELIVERY_ALIAS_REQ == '1'}checked="checked"{/if}
                                    data-required="1"
                                    data-field-value="wk_checkout_delivery_alias_show"
                                    class="wk_delivery_req_field"
                                    type="checkbox"
                                    value="2"
                                    name="wk_checkout_delivery_alias_req"
                                    id="wk_checkout_delivery_alias_req">
                                <span>{l s='Required' mod='wkonepagecheckout'}</span>
                            </label>
                        </div>
                    </div>                    
                </div>
                <div class="panel-footer">
                    <button type="submit" name="submitDeliveryAddress" class="btn btn-default pull-right">
                        <i class="process-icon-save"></i> {l s='Save' mod='wkonepagecheckout'}
                    </button>
                </div>
            </form>
        </div>
    </div>
    <div class="col-sm-1" style="width:1%;"></div>
    <div class="col-sm-5 panel" style="width:48%;">
        <div class="panel-heading">
            <p>{l s='Invoice Address' mod='wkonepagecheckout'}</p>
        </div>
        <div class="panel-body">
            <form action="" class="defaultForm form-horizontal" method="post" enctype="multipart/form-data">
                <div class="form-wrapper">
                    <div class="form-group">
                        <label class="control-label col-lg-5">
                            <span title="" data-html="true" data-toggle="tooltip" class="label-tooltip" data-original-title="{l s='Show company input field for invoice address' mod='wkonepagecheckout'}">{l s='Company : ' mod='wkonepagecheckout'}</span>
                        </label>
                        <div class="col-lg-6 col-md-offset-1 checkbox">
                            <label class="custom_checkbox">
                                <input
                                    {if $configValues.WK_CHECKOUT_INVOICE_COMPANY_SHOW == '1'}checked="checked"{/if}
                                    data-required="0"
                                    data-field-value="wk_checkout_invoice_company_req"
                                    class="wk_delivery_req_field"
                                    type="checkbox"
                                    value="1"
                                    name="wk_checkout_invoice_company_show"
                                    id="wk_checkout_invoice_company_show">
                                <span>{l s='Show' mod='wkonepagecheckout'}</span>
                            </label>
                            <label class="custom_checkbox">
                                <input
                                    {if $configValues.WK_CHECKOUT_INVOICE_COMPANY_REQ == '1'}checked="checked"{/if}
                                    data-required="1"
                                    data-field-value="wk_checkout_invoice_company_show"
                                    class="wk_delivery_req_field"
                                    type="checkbox"
                                    value="2"
                                    name="wk_checkout_invoice_company_req"
                                    id="wk_checkout_invoice_company_req">
                                <span>{l s='Required' mod='wkonepagecheckout'}</span>
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-lg-5">
                            <span title="" data-html="true" data-toggle="tooltip" class="label-tooltip" data-original-title="{l s='Show DNI number input field for invoice address' mod='wkonepagecheckout'}">{l s='DNI Number : ' mod='wkonepagecheckout'}</span>
                        </label>
                        <div class="col-lg-6 col-md-offset-1 checkbox">
                            <label class="custom_checkbox">
                                <input
                                    {if $configValues.WK_CHECKOUT_INVOICE_DNI_SHOW == '1'}checked="checked"{/if}
                                    data-required="0"
                                    data-field-value="wk_checkout_invoice_dni_req"
                                    class="wk_delivery_req_field"
                                    type="checkbox"
                                    value="1"
                                    name="wk_checkout_invoice_dni_show"
                                    id="wk_checkout_invoice_dni_show">
                                <span>{l s='Show' mod='wkonepagecheckout'}</span>
                            </label>
                            <label class="custom_checkbox">
                                <input
                                    {if $configValues.WK_CHECKOUT_INVOICE_DNI_REQ == '1'}checked="checked"{/if}
                                    data-required="1"
                                    data-field-value="wk_checkout_invoice_dni_show"
                                    class="wk_delivery_req_field"
                                    type="checkbox"
                                    value="2"
                                    name="wk_checkout_invoice_dni_req"
                                    id="wk_checkout_invoice_dni_req">
                                <span>{l s='Required' mod='wkonepagecheckout'}</span>
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-lg-5">
                            <span title="" data-html="true" data-toggle="tooltip" class="label-tooltip" data-original-title="{l s='Show address alias input field for delivery address' mod='wkonepagecheckout'}">{l s='Number : ' mod='wkonepagecheckout'}</span>
                        </label>
                        <div class="col-lg-6 col-md-offset-1 checkbox">
                            <label class="custom_checkbox">
                                <input
                                    {if $configValues.WK_CHECKOUT_INVOICE_NUMBER_SHOW == '1'}checked="checked"{/if}
                                    data-required="0"
                                    data-field-value="wk_checkout_invoice_number_req"
                                    class="wk_invoice_req_field"
                                    type="checkbox"
                                    value="1"
                                    name="wk_checkout_invoice_number_show"
                                    id="wk_checkout_invoice_number_show">
                                <span>{l s='Show' mod='wkonepagecheckout'}</span>
                            </label>
                            <label class="custom_checkbox">
                                <input
                                    {if $configValues.WK_CHECKOUT_INVOICE_NUMBER_REQ == '1'}checked="checked"{/if}
                                    data-required="1"
                                    data-field-value="wk_checkout_invoice_number_show"
                                    class="wk_invoice_req_field"
                                    type="checkbox"
                                    value="2"
                                    name="wk_checkout_invoice_number_req"
                                    id="wk_checkout_invoice_number_req">
                                <span>{l s='Required' mod='wkonepagecheckout'}</span>
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-lg-5">
                            <span title="" data-html="true" data-toggle="tooltip" class="label-tooltip" data-original-title="{l s='Show other information input field for invoice address' mod='wkonepagecheckout'}">{l s='Other Information : ' mod='wkonepagecheckout'}</span>
                        </label>
                        <div class="col-lg-6 col-md-offset-1 checkbox">
                            <label class="custom_checkbox">
                                <input
                                    {if $configValues.WK_CHECKOUT_INVOICE_OTHER_SHOW == '1'}checked="checked"{/if}
                                    data-required="0"
                                    data-field-value="wk_checkout_invoice_other_req"
                                    class="wk_delivery_req_field"
                                    type="checkbox"
                                    value="1"
                                    name="wk_checkout_invoice_other_show"
                                    id="wk_checkout_invoice_other_show">
                                <span>{l s='Show' mod='wkonepagecheckout'}</span>
                            </label>
                            <label class="custom_checkbox">
                                <input
                                    {if $configValues.WK_CHECKOUT_INVOICE_OTHER_REQ == '1'}checked="checked"{/if}
                                    data-required="1"
                                    data-field-value="wk_checkout_invoice_other_show"
                                    class="wk_delivery_req_field"
                                    type="checkbox"
                                    value="2"
                                    name="wk_checkout_invoice_other_req"
                                    id="wk_checkout_invoice_other_req">
                                <span>{l s='Required' mod='wkonepagecheckout'}</span>
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-lg-5">
                            <span title="" data-html="true" data-toggle="tooltip" class="label-tooltip" data-original-title="{l s='Show address complement input field for invoice address' mod='wkonepagecheckout'}">{l s='Address Complement : ' mod='wkonepagecheckout'}</span>
                        </label>
                        <div class="col-lg-6 col-md-offset-1 checkbox">
                            <label class="custom_checkbox">
                                <input
                                    {* Adriana - 15/07/2020 - início *}
                                    {*
                                    {if $configValues.WK_CHECKOUT_INVOICE_ADDRESS_COMPANY_SHOW == '1'}checked="checked"{/if}
                                    *}
                                    {if $configValues.WK_CHECKOUT_INVOICE_ADDRESS_COMPLEM_SHOW == '1'}checked="checked"{/if}
                                    {* Adriana - 15/07/2020 - fim *}
                                    data-required="0"
                                    data-field-value="wk_checkout_invoice_add_comp_req"
                                    class="wk_delivery_req_field"
                                    type="checkbox"
                                    value="1"
                                    name="wk_checkout_invoice_add_comp_show"
                                    id="wk_checkout_invoice_add_comp_show">
                                <span>{l s='Show' mod='wkonepagecheckout'}</span>
                            </label>
                            <label class="custom_checkbox">
                                <input
                                    {* Adriana - 15/07/2020 - início *}
                                    {*                                
                                    {if $configValues.WK_CHECKOUT_INVOICE_ADDRESS_COMPANY_REQ == '1'}checked="checked"{/if}
                                    *}
                                    {if $configValues.WK_CHECKOUT_INVOICE_ADDRESS_COMPLEM_REQ == '1'}checked="checked"{/if}
                                    {* Adriana - 15/07/2020 - fim *}
                                    data-required="1"
                                    data-field-value="wk_checkout_invoice_add_comp_show"
                                    class="wk_delivery_req_field"
                                    type="checkbox"
                                    value="2"
                                    name="wk_checkout_invoice_add_comp_req"
                                    id="wk_checkout_invoice_add_comp_req">
                                <span>{l s='Required' mod='wkonepagecheckout'}</span>
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-lg-5">
                            <span title="" data-html="true" data-toggle="tooltip" class="label-tooltip" data-original-title="{l s='Show mobile phone input field for invoice address' mod='wkonepagecheckout'}">{l s='Mobile Phone : ' mod='wkonepagecheckout'}</span>
                        </label>
                        <div class="col-lg-6 col-md-offset-1 checkbox">
                            <label class="custom_checkbox">
                                <input
                                    {if $configValues.WK_CHECKOUT_INVOICE_MOBILE_PHONE_SHOW == '1'}checked="checked"{/if}
                                    data-required="0"
                                    data-field-value="wk_checkout_invoice_mobile_phone_req"
                                    class="wk_delivery_req_field"
                                    type="checkbox"
                                    value="1"
                                    name="wk_checkout_invoice_mobile_phone_show"
                                    id="wk_checkout_invoice_mobile_phone_show">
                                <span>{l s='Show' mod='wkonepagecheckout'}</span>
                            </label>
                            <label class="custom_checkbox">
                                <input
                                    {if $configValues.WK_CHECKOUT_INVOICE_MOBILE_PHONE_REQ == '1'}checked="checked"{/if}
                                    data-required="1"
                                    data-field-value="wk_checkout_invoice_mobile_phone_show"
                                    class="wk_delivery_req_field"
                                    type="checkbox"
                                    value="2"
                                    name="wk_checkout_invoice_mobile_phone_req"
                                    id="wk_checkout_invoice_mobile_phone_req">
                                <span>{l s='Required' mod='wkonepagecheckout'}</span>
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-lg-5">
                            <span title="" data-html="true" data-toggle="tooltip" class="label-tooltip" data-original-title="{l s='Show phone input field for invoice address' mod='wkonepagecheckout'}">{l s='Phone : ' mod='wkonepagecheckout'}</span>
                        </label>
                        <div class="col-lg-6 col-md-offset-1 checkbox">
                            <label class="custom_checkbox">
                                <input
                                    {if $configValues.WK_CHECKOUT_INVOICE_PHONE_SHOW == '1'}checked="checked"{/if}
                                    data-required="0"
                                    data-field-value="wk_checkout_invoice_phone_req"
                                    class="wk_delivery_req_field"
                                    type="checkbox"
                                    value="1"
                                    name="wk_checkout_invoice_phone_show"
                                    id="wk_checkout_invoice_phone_show">
                                <span>{l s='Show' mod='wkonepagecheckout'}</span>
                            </label>
                            <label class="custom_checkbox">
                                <input
                                    {if $configValues.WK_CHECKOUT_INVOICE_PHONE_REQ == '1'}checked="checked"{/if}
                                    data-required="1"
                                    data-field-value="wk_checkout_invoice_phone_show"
                                    class="wk_delivery_req_field"
                                    type="checkbox"
                                    value="2"
                                    name="wk_checkout_invoice_phone_req"
                                    id="wk_checkout_invoice_phone_req">
                                <span>{l s='Required' mod='wkonepagecheckout'}</span>
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-lg-5">
                            <span title="" data-html="true" data-toggle="tooltip" class="label-tooltip" data-original-title="{l s='Show address alias input field for invoice address' mod='wkonepagecheckout'}">{l s='Address Alias : ' mod='wkonepagecheckout'}</span>
                        </label>
                        <div class="col-lg-6 col-md-offset-1 checkbox">
                            <label class="custom_checkbox">
                                <input
                                    {if $configValues.WK_CHECKOUT_INVOICE_ALIAS_SHOW == '1'}checked="checked"{/if}
                                    data-required="0"
                                    data-field-value="wk_checkout_invoice_alias_req"
                                    class="wk_delivery_req_field"
                                    type="checkbox"
                                    value="1"
                                    name="wk_checkout_invoice_alias_show"
                                    id="wk_checkout_invoice_alias_show">
                                <span>{l s='Show' mod='wkonepagecheckout'}</span>
                            </label>
                            <label class="custom_checkbox">
                                <input
                                    {if $configValues.WK_CHECKOUT_INVOICE_ALIAS_REQ == '1'}checked="checked"{/if}
                                    data-required="1"
                                    data-field-value="wk_checkout_invoice_alias_show"
                                    class="wk_delivery_req_field"
                                    type="checkbox"
                                    value="2"
                                    name="wk_checkout_invoice_alias_req"
                                    id="wk_checkout_invoice_alias_req">
                                <span>{l s='Required' mod='wkonepagecheckout'}</span>
                            </label>
                        </div>
                    </div>
                </div>
                <div class="panel-footer">
                    <button type="submit" name="submitInvoiceAddress" class="btn btn-default pull-right">
                        <i class="process-icon-save"></i> {l s='Save' mod='wkonepagecheckout'}
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
