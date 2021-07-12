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

<div class="wk-condition wk-box">
    <div id="hook-display-after-payment-options">
        {hook h='displayAfterPaymentOptions'}
    </div>
    <article class="col-md-12 wkpadding" id="zipvalidatorhide">
        {if $conditions_to_approve|count}
            <p class="ps-hidden-by-js">
                {l s='By confirming the order, you certify that you have read and agree with all of the conditions below:' mod='wkonepagecheckout'}
            </p>
            <form id="conditions-to-approve" method="GET">
                <ul>
                    {foreach from=$conditions_to_approve item="condition" key="condition_name"}
                        <li>
                            <div class="float-xs-left">
                                <span class="custom-checkbox">
                                    <input id="conditions_to_approve[{$condition_name}]"
                                        name="conditions_to_approve[{$condition_name}]" required type="checkbox" value="1"
                                        class="ps-shown-by-js wk-condition-check" checked="checked">
                                    <span><i class="material-icons checkbox-checked">&#xE5CA;</i></span>
                                </span>
                            </div>
                            <div class="condition-label">
                                <label class="js-terms"
                                    for="conditions_to_approve[{$condition_name}]">{$condition nofilter}</label>
                            </div>
                        </li>
                    {/foreach}
                </ul>
            </form>
        {/if}
        <div id="wk-payment-confirmation">
            <div class="ps-shown-by-js">
                <button type="submit" class="btn btn-primary center-block wkcustomizerbtn"
                    {if isset($extra_msg) && $extra_msg} disabled {/if}>
                    {l s='Order with an obligation to pay' mod='wkonepagecheckout'}
                </button>
            </div>
        </div>

        {* Danger : - Dont't alter this div, we have used this div to append prestashop button to make payment *}
        <div class="wk_ps_payment_button wkhide"></div>
        {*  *}

        <div id="wkcondition_info"></div>
    </article>
</div>


{* Load CMS pop for terms and condition*}
<div class="modal fade" id="modal">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">×</span>
            </button>
            <div class="js-modal-content"></div>
        </div>
    </div>
</div>
<style>
    .wkcustomizerbtn {
        background-color : {Configuration::get('WK_CHECKOUT_BUTTON_COLOR')} !important;
        font-size: {Configuration::get('WK_CHECKOUT_BUTTON_FONT_SIZE')}px !important;
        color: {Configuration::get('WK_CHECKOUT_BUTTON_FONT_COLOR')} !important;
        font-family: {$fontfamily} !important;
    }
</style>