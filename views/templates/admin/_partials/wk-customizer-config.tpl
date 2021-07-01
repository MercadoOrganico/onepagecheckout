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
    <div class="form-group">
        <label class="control-label col-lg-3 required">
            {l s='Checkout Button Color : ' mod='wkonepagecheckout'}
        </label>
        <div class="input-group col-lg-3">
            <input type="color" data-hex="true" class="color" name="wk_checkout_button_color" value="{$configValues.WK_CHECKOUT_BUTTON_COLOR}" />
        </div>
        <div class="help-block col-md-offset-3">{l s='Button color will change on one page checkout page' mod='wkonepagecheckout'}</div>
    </div>
    <div class="form-group">
        <label class="control-label col-lg-3 required">
            {l s='Checkout Button Font size : ' mod='wkonepagecheckout'}
        </label>
        <div class="input-group col-lg-3">
            <input type="text" class="form-control" name="wk_checkout_button_font_size" value="{$configValues.WK_CHECKOUT_BUTTON_FONT_SIZE}" maxlength="2" />
        </div>
    </div>
    <div class="form-group">
        <label class="control-label col-lg-3 required">
            {l s='Checkout Button Font Color : ' mod='wkonepagecheckout'}
        </label>
        <div class="input-group col-lg-3">
            <input type="color" data-hex="true" class="form-control" name="wk_checkout_button_font_color" value="{$configValues.WK_CHECKOUT_BUTTON_FONT_COLOR}"/>
        </div>
    </div>
    <div class="form-group">
        <label class="control-label col-lg-3">
            {l s='Checkout Button Font Family : ' mod='wkonepagecheckout'}
        </label>
        <div class="input-group col-lg-3">
            <select name="wk_checkout_button_font_family">
                <option value="1" {if $configValues.WK_CHECKOUT_BUTTON_FONT_FAMILY == 1} selected="selected"{/if}>
                    Arial, Helvetica, sans-serif
                </option>
                <option value="2" {if $configValues.WK_CHECKOUT_BUTTON_FONT_FAMILY == 2} selected="selected"{/if}>
                    Comic Sans MS,cursive,sans-serif
                </option>
                <option value="3" {if $configValues.WK_CHECKOUT_BUTTON_FONT_FAMILY == 3} selected="selected"{/if}>
                    Lucida Sans Unicode, Lucida Grande, sans-serif
                </option>
                <option value="4" {if $configValues.WK_CHECKOUT_BUTTON_FONT_FAMILY == 4} selected="selected"{/if}>
                    Courier New, Courier, monospace
                </option>
                <option value="5" {if $configValues.WK_CHECKOUT_BUTTON_FONT_FAMILY == 5} selected="selected"{/if}>
                    Lucida Console, Monaco, monospace
                </option>
                <option value="6" {if $configValues.WK_CHECKOUT_BUTTON_FONT_FAMILY == 6} selected="selected"{/if}>
                    Montserrat, sans-serif
                </option>
            </select>
        </div>
    </div>
    <div class="panel-footer">
        <button type="submit" name="submitCustomizer" class="btn btn-default pull-right">
            <i class="process-icon-save"></i> {l s='Save' mod='wkonepagecheckout'}
        </button>
    </div>
</form>
