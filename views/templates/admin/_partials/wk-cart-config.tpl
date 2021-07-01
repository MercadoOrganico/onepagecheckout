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

<form action="{$currentIndex}" class="defaultForm form-horizontal" method="post" enctype="multipart/form-data">
    <div class="form-wrapper">
        <div class="form-group">
            <label class="control-label col-lg-3">
                {l s='Show cart details before checkout : ' mod='wkonepagecheckout'}
            </label>
            <div class="col-lg-9 ">
                <span class="switch prestashop-switch fixed-width-lg">
                    <input type="radio" name="wk_checkout_cart_detail" id="wk_checkout_cart_detail_on" value="1"
                    {if isset($smarty.post.wk_checkout_cart_detail) && $smarty.post.wk_checkout_cart_detail == 1}checked="checked"
                    {else if isset($configValues) && $configValues.WK_CHECKOUT_CART_DETAIL == 1}checked="checked"
                    {else if !isset($smarty.post.wk_checkout_cart_detail)}checked="checked"{/if}>
                    <label for="wk_checkout_cart_detail_on">{l s='Yes' mod='wkonepagecheckout'}</label>
                    {if isset($configValues)}
                    <input type="radio" name="wk_checkout_cart_detail" id="wk_checkout_cart_detail_off" value="0" {if $configValues.WK_CHECKOUT_CART_DETAIL == '0'}checked="checked"{else if isset($smarty.post.wk_checkout_cart_detail) && $smarty.post.wk_checkout_cart_detail == '0'}checked="checked"{/if}>
                    {else}
                    <input type="radio" name="wk_checkout_cart_detail" id="wk_checkout_cart_detail_off" value="0" {if isset($smarty.post.wk_checkout_cart_detail) && $smarty.post.wk_checkout_cart_detail == '0'}checked="checked"{/if}>
                    {/if}
                    <label for="wk_checkout_cart_detail_off">{l s='No' mod='wkonepagecheckout'}</label>
                    <a class="slide-button btn"></a>
                </span>
            </div>
        </div>
        <div class="form-group">
            <label class="control-label col-lg-3">
                {l s='Allow customer to save for later : ' mod='wkonepagecheckout'}
            </label>
            <div class="col-lg-9 ">
                <span class="switch prestashop-switch fixed-width-lg">
                    <input type="radio" name="wk_checkout_cart_save_later" id="wk_checkout_cart_save_later_on" value="1"
                    {if isset($smarty.post.wk_checkout_cart_save_later) && $smarty.post.wk_checkout_cart_save_later == 1}checked="checked"
                    {else if isset($configValues) && $configValues.WK_CHECKOUT_CART_SAVE_LATER == 1}checked="checked"
                    {else if !isset($smarty.post.wk_checkout_cart_save_later)}checked="checked"{/if}>
                    <label for="wk_checkout_cart_save_later_on">{l s='Yes' mod='wkonepagecheckout'}</label>
                    {if isset($configValues)}
                    <input type="radio" name="wk_checkout_cart_save_later" id="wk_checkout_cart_save_later_off" value="0" {if $configValues.WK_CHECKOUT_CART_SAVE_LATER == '0'}checked="checked"{else if isset($smarty.post.wk_checkout_cart_save_later) && $smarty.post.wk_checkout_cart_save_later == '0'}checked="checked"{/if}>
                    {else}
                    <input type="radio" name="wk_checkout_cart_save_later" id="wk_checkout_cart_save_later_off" value="0" {if isset($smarty.post.wk_checkout_cart_save_later) && $smarty.post.wk_checkout_cart_save_later == '0'}checked="checked"{/if}>
                    {/if}
                    <label for="wk_checkout_cart_save_later_off">{l s='No' mod='wkonepagecheckout'}</label>
                    <a class="slide-button btn"></a>
                </span>
                <div class="help-block">{l s='Customer can save cart product for future purchase' mod='wkonepagecheckout'}</div>
            </div>
        </div>
        <div class="form-group">
            <label class="control-label col-lg-3">
                {l s='Show who bought also bought feature below the checkout page : ' mod='wkonepagecheckout'}
            </label>
            <div class="col-lg-9 ">
                <span class="switch prestashop-switch fixed-width-lg">
                    <input type="radio" name="wk_checkout_cart_also_bought" id="wk_checkout_cart_also_bought_on" value="1"
                    {if isset($smarty.post.wk_checkout_cart_also_bought) && $smarty.post.wk_checkout_cart_also_bought == 1}checked="checked"
                    {else if isset($configValues) && $configValues.WK_CHECKOUT_CART_ALSO_BOUGHT == 1}checked="checked"
                    {else if !isset($smarty.post.wk_checkout_cart_also_bought)}checked="checked"{/if}>
                    <label for="wk_checkout_cart_also_bought_on">{l s='Yes' mod='wkonepagecheckout'}</label>
                    {if isset($configValues)}
                    <input type="radio" name="wk_checkout_cart_also_bought" id="wk_checkout_cart_also_bought_off" value="0" {if $configValues.WK_CHECKOUT_CART_ALSO_BOUGHT == '0'}checked="checked"{else if isset($smarty.post.wk_checkout_cart_also_bought) && $smarty.post.wk_checkout_cart_also_bought == '0'}checked="checked"{/if}>
                    {else}
                    <input type="radio" name="wk_checkout_cart_also_bought" id="wk_checkout_cart_also_bought_off" value="0" {if isset($smarty.post.wk_checkout_cart_also_bought) && $smarty.post.wk_checkout_cart_also_bought == '0'}checked="checked"{/if}>
                    {/if}
                    <label for="wk_checkout_cart_also_bought_off">{l s='No' mod='wkonepagecheckout'}</label>
                    <a class="slide-button btn"></a>
                </span>
            </div>
        </div>
        <div class="form-group wk_checkout_also_bought_number">
            <label class="control-label col-lg-3 required">
                {l s='Number of displayed products : ' mod='wkonepagecheckout'}
            </label>
            <div class="col-lg-3">
                <input type="text" value="{$configValues.WK_CHECKOUT_ALSO_BOUGHT_NUMBER}" id="wk_checkout_also_bought_number" name="wk_checkout_also_bought_number">
                <div class="help-block">{l s='Set the number of products displayed in this block.' mod='wkonepagecheckout'} </div>
            </div>
        </div>
        <div class="form-group">
            <label class="control-label col-lg-3">
                {l s='Size of Product image on cart : ' mod='wkonepagecheckout'}
            </label>
            <div class="col-lg-3">
                <select name="wk_checkout_product_image" id="wk_checkout_product_image">
                    <option {if $configValues.WK_CHECKOUT_PRODUCT_IMAGE == '1'}selected="selected"{/if} value="1">{l s='50 x 50' mod='wkonepagecheckout'}</option>
                    <option {if $configValues.WK_CHECKOUT_PRODUCT_IMAGE == '2'}selected="selected"{/if} value="2">{l s='80 x 80' mod='wkonepagecheckout'}</option>
                    <option {if $configValues.WK_CHECKOUT_PRODUCT_IMAGE == '3'}selected="selected"{/if} value="3">{l s='100 x 100' mod='wkonepagecheckout'}</option>
                </select>
                <div class="help-block">{l s='Set width x height of product image on cart' mod='wkonepagecheckout'}</div>
            </div>
        </div>
        <div class="form-group">
            <label class="control-label col-lg-3">
                {l s='Terms of service : ' mod='wkonepagecheckout'}
            </label>
            <div class="col-lg-9 ">
                <span class="switch prestashop-switch fixed-width-lg">
                    <input type="radio" name="wk_checkout_terms_service" id="wk_checkout_terms_service_on" value="1"
                    {if isset($smarty.post.wk_checkout_terms_service) && $smarty.post.wk_checkout_terms_service == 1}checked="checked"
                    {else if isset($configValues) && $configValues.WK_CHECKOUT_TERMS_SERVICE == 1}checked="checked"
                    {else if !isset($smarty.post.wk_checkout_terms_service)}checked="checked"{/if}>
                    <label for="wk_checkout_terms_service_on">{l s='Yes' mod='wkonepagecheckout'}</label>
                    {if isset($configValues)}
                    <input type="radio" name="wk_checkout_terms_service" id="wk_checkout_terms_service_off" value="0" {if $configValues.WK_CHECKOUT_TERMS_SERVICE == '0'}checked="checked"{else if isset($smarty.post.wk_checkout_terms_service) && $smarty.post.wk_checkout_terms_service == '0'}checked="checked"{/if}>
                    {else}
                    <input type="radio" name="wk_checkout_terms_service" id="wk_checkout_terms_service_off" value="0" {if isset($smarty.post.wk_checkout_terms_service) && $smarty.post.wk_checkout_terms_service == '0'}checked="checked"{/if}>
                    {/if}
                    <label for="wk_checkout_terms_service_off">{l s='No' mod='wkonepagecheckout'}</label>
                    <a class="slide-button btn"></a>
                </span>
            </div>
        </div>
         <div class="form-group wk_checkout_terms_option">
            <label class="control-label col-lg-3 required">
                {l s='Page for Terms and Condition : ' mod='wkonepagecheckout'}
            </label>
            <div class="col-lg-3">
                <select name="wk_checkout_terms_option" id="wk_checkout_terms_option" class="form-control">
                    <option value="0">--</option>
                    {if isset($cmsCondition) && $cmsCondition}
                        {foreach $cmsCondition as $condition}
                            <option {if $configValues.WK_CHECKOUT_TERMS_OPTION == $condition.id_cms}selected="selected"{/if} value="{$condition.id_cms}">{$condition.meta_title}</option>
                        {/foreach}
                    {/if}
                </select>
            </div>
        </div>
    </div>
    <div class="panel-footer">
        <button type="submit" name="submitCart" class="btn btn-default pull-right">
            <i class="process-icon-save"></i> {l s='Save' mod='wkonepagecheckout'}
        </button>
    </div>
</form>
