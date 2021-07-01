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
    <ul class="nav nav-pills nav-tabs" id="wk-checkout-config">
        <li class="nav-item {if isset($generalError)} active {elseif isset($tabActive)}{if $tabActive == 'general'}active{/if}{else}{if !isset($generalError) && !isset($customizerError) && !isset($socialError) && !isset($cartError)}active{/if}{/if}">
            <a class="nav-link" href="#wkgeneralsetting" data-toggle="tab">
                <i class="icon-wrench"></i>
                {l s='General Setting' mod='wkonepagecheckout'}
            </a>
        </li>
        <li class="nav-item {if isset($customizerError)} active {elseif isset($tabActive)}{if $tabActive == 'customizer'}active{/if}{/if}">
            <a class="nav-link" href="#wkcustomizer" data-toggle="tab">
                <i class="icon-paint-brush"> </i>
                {l s='Customization' mod='wkonepagecheckout'}
            </a>
        </li>
        <li class="nav-item {if isset($tabActive)}{if $tabActive == 'loginregister'}active{/if}{/if}">
            <a class="nav-link" href="#wkloginregister" data-toggle="tab">
                <i class="icon-user"> </i>
                {l s='Login & Register' mod='wkonepagecheckout'}
            </a>
        </li>
        <li class="nav-item {if isset($tabActive)}{if $tabActive == 'address'}active{/if}{/if}">
            <a class="nav-link" href="#wkaddress" data-toggle="tab">
                <i class="icon-book"> </i>
                {l s='Address' mod='wkonepagecheckout'}
            </a>
        </li>
        <li class="nav-item {if isset($tabActive)}{if $tabActive == 'shipping'}active{/if}{/if}">
            <a class="nav-link" href="#wkshipping" data-toggle="tab">
                <i class="icon-truck"> </i>
                {l s='Shipping' mod='wkonepagecheckout'}
            </a>
        </li>
        <li class="nav-item {if isset($tabActive)}{if $tabActive == 'payment'}active{/if}{/if}">
            <a class="nav-link" href="#wkpayment" data-toggle="tab">
                <i class="icon-money"> </i>
                {l s='Payment' mod='wkonepagecheckout'}
            </a>
        </li>
        <li class="nav-item {if isset($socialError)} active {elseif isset($tabActive)}{if $tabActive == 'sociallogin'}active{/if}{/if}">
            <a class="nav-link" href="#wksociallogin" data-toggle="tab">
                <i class="icon-share"> </i>
                {l s='Social Login' mod='wkonepagecheckout'}
            </a>
        </li>
        <li class="nav-item {if isset($cartError)} active {elseif isset($tabActive)}{if $tabActive == 'cart'}active{/if}{/if}">
            <a class="nav-link" href="#wkcart" data-toggle="tab">
                <i class="icon-shopping-cart"> </i>
                {l s='Cart' mod='wkonepagecheckout'}
            </a>
        </li>
        {*<li class="nav-item {if isset($tabActive)}{if $tabActive == 'design'}active{/if}{/if}">
            <a class="nav-link" href="#wkdesign" data-toggle="tab">
                <i class="icon-edit"> </i>
                {l s='Design' mod='wkonepagecheckout'}
            </a>
        </li>*}
    </ul>
    <div id="wk_config_details" class="tab-content panel collapse in">
        <div class="tab-pane  {if isset($generalError)} active {elseif isset($tabActive)}{if $tabActive == 'general'}active{/if}{else}{if !isset($generalError) && !isset($customizerError) && !isset($socialError) && !isset($cartError)}active{/if}{/if}" id="wkgeneralsetting">
            {include file="$self/views/templates/admin/_partials/wk-general-config.tpl"}
        </div>
        <div class="tab-pane {if isset($customizerError)} active {elseif isset($tabActive)}{if $tabActive == 'customizer'}active{/if}{/if}" id="wkcustomizer">
            {include file="$self/views/templates/admin/_partials/wk-customizer-config.tpl"}
        </div>
        <div class="tab-pane {if isset($tabActive)}{if $tabActive == 'loginregister'}active{/if}{/if}" id="wkloginregister">
            {include file="$self/views/templates/admin/_partials/wk-login-register-config.tpl"}
        </div>
        <div class="tab-pane {if isset($tabActive)}{if $tabActive == 'address'}active{/if}{/if}" id="wkaddress">
            {include file="$self/views/templates/admin/_partials/wk-address-config.tpl"}
        </div>
        <div class="tab-pane {if isset($tabActive)}{if $tabActive == 'shipping'}active{/if}{/if}" id="wkshipping">
            {include file="$self/views/templates/admin/_partials/wk-shipping-config.tpl"}
        </div>
        <div class="tab-pane {if isset($tabActive)}{if $tabActive == 'payment'}active{/if}{/if}" id="wkpayment">
            {include file="$self/views/templates/admin/_partials/wk-payment-config.tpl"}
        </div>
        <div class="tab-pane {if isset($socialError)} active {elseif isset($tabActive)}{if $tabActive == 'sociallogin'}active{/if}{/if}" id="wksociallogin">
            {include file="$self/views/templates/admin/_partials/wk-social-login.tpl"}
        </div>
        <div class="tab-pane {if isset($cartError)} active {elseif isset($tabActive)}{if $tabActive == 'cart'}active{/if}{/if}" id="wkcart">
            {include file="$self/views/templates/admin/_partials/wk-cart-config.tpl"}
        </div>
        {*<div class="tab-pane {if isset($tabActive)}{if $tabActive == 'design'}active{/if}{/if}" id="wkdesign">
            {include file="$self/views/templates/admin/_partials/wk-design-config.tpl"}
        </div>*}
    </div>
</div>
