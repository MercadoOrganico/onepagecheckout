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

<div>
	<h4 id="myModalLabel"><i class="material-icons">&#xE851;</i>{l s='Log in' mod='wkonepagecheckout'}</h4>
</div>

<div class="wk-modal-dialog" id="wk-modal-dialog">

	<form method="POST" action="{url entity='module' name='wkonepagecheckout' controller='wkcheckout'}" id="wk-login-form" name="wk-login-form">
			<div class="alert alert-danger wk-login-error wkhide"></div>
				<div class="form-group">
					<div class="input-group">
						<input type="text" class="form-control" name="wk-login-email" id="wk-login-email" placeholder="{l s='Email' mod='wkonepagecheckout'}">
						<label class="input-group-addon wk-icon">
							<i class="material-icons">&#xE851;</i>
						</label>
					</div>
				</div>

				<div class="form-group">
					<div class="input-group">
						<input type="password" class="form-control" name="wk-login-password" id="wk-login-password" placeholder="{l s='Password' mod='wkonepagecheckout'}">
						<label for="uPassword" class="input-group-addon wk-icon">
							<i class="material-icons">&#xE897;</i>
						</label>
					</div>
				</div>

		{* Adriana - 21/09/2020 - início *}
		{*<div class="modal-footer">*}
		<div class="wk-modal-footer">
			{* Adriana - 21/09/2020 - fim *}
			<img class="wk-loader wkhide" src="{$wk_opc_modules_dir}img/p_loading.gif" width="25">
			<button class="btn btn-primary" id="wk-submit-login">
				{l s='Login' mod='wkonepagecheckout'}
			</button>
			<div class="wkforgot">
				<a href="{$urls.pages.password}" class="forget">{l s='Forgot your password?' mod='wkonepagecheckout'}</a>
			</div>
		</div>
	</form>
</div>

{* Adriana - 03/11/2020 - início *}
{*<div>*}
<div class="wk-modal-dialog">
{* Adriana - 03/11/2020 - fim *}
	{if Configuration::get('WK_CHECKOUT_SOCIAL_LOGIN')}
		{if Configuration::get('WK_CHECKOUT_FACEBOOK_LOGIN') || Configuration::get('WK_CHECKOUT_GOOGLE_LOGIN')}
		<!-- If customer is not login -->
		<div class="wk-social-login">
			<p class="wk-separator">{l s='Or' mod='wkonepagecheckout'}</p>
			<h5>{l s='Sign in with' mod='wkonepagecheckout'}</h5>
			<div id="status" class="wkerrorcolor"></div>
			{if Configuration::get('WK_CHECKOUT_FACEBOOK_LOGIN')}
				{* Adriana - 10/08/2020 - início *}
				{*<a class="btn btn-primary wkbtn-fb" href="javascript:void(0);" onclick="fbLogin()" id="fbLink">
						<span>{l s='Facebook' mod='wkonepagecheckout'}</span>
				</a>*}
				<div id="fbloginblock-beforeauthpage">
					<a class="btn wkbtn-fb" href="javascript:void(0);" id="fbLink" onclick="javascript:popupWin = window.open('https://www.facebook.com/v2.10/dialog/oauth?client_id=1861866097476934&amp;state=73ab1ab0392c3bab5387211cd1dd0a51&amp;response_type=code&amp;sdk=php-sdk-5.5.0&amp;redirect_uri=https%3A%2F%2Fmercadoorganico.com%2Findex.php%3Ffc%3Dmodule%26module%3Dfbloginblock%26controller%3Dspmlogin%26typelogin%3Dfacebook&amp;scope=email', 'login', 'location,width=600,height=600,top=0'); popupWin.focus();" title="Facebook">					
						<span>{l s='Facebook' mod='wkonepagecheckout'}</span>
					</a>
				</div>
				{* Adriana - 10/08/2020 - fim *}
			{/if}
			{if Configuration::get('WK_CHECKOUT_GOOGLE_LOGIN')}
				<a class="btn btn-primary wkbtn-google" href="javascript:void(0);" id="customGmailBtn">
					<span>{l s='Google' mod='wkonepagecheckout'}</span>
				</a>
			{/if}
		</div>
		{/if}
	{/if}
	<p class="wk-separator">{l s='Or' mod='wkonepagecheckout'}</p>
	<div class="wk-guest-checkout">
		{if Configuration::get('WK_CHECKOUT_GUEST_ALLOW')}
			<h5>{l s='Guest Checkout' mod='wkonepagecheckout'}</h5>
		{else}
			<h5>{l s='Create Account' mod='wkonepagecheckout'}</h5>
		{/if}
	</div>

	<div class="wk-form-group">
		{if Configuration::get('WK_CHECKOUT_SOCIAL_TITLE')}
		<div class="form-group">
			<label class="label-control">{l s='Social title' mod='wkonepagecheckout'}</label>
			{if isset($genders)}
				{foreach from=$genders item="label" key="value"}
					<div class="wk-gender">
						<input type="radio" name="id_gender" value="{$value}">
						<label for="id_gender">{$label}</label>
					</div>
				{/foreach}
			{/if}
		</div>
		{/if}
		<div class="form-group">
			<label class="label-control">{l s='Email' mod='wkonepagecheckout'}</label>
			<input
				value="{if isset($wkguest)}{$wkguest->email}{/if}"
				maxlength="128"
				type="text"
				name="wk-email"
				id="wk-email"
				{if isset($wkguest)}
					readonly="readonly" disabled="disabled"
				{/if}
				class="form-control">
			<i class="material-icons wk-check-icon wkhide icon_wk_email">&#xE876;</i>
			<i class="material-icons wk-error-icon wkhide error_wk_email">&#xE001;</i>
			<span id="wk-email-error" class="wkerrorcolor"></span>
		</div>
		{if Configuration::get('WK_CHECKOUT_GUEST_ALLOW') && !isset($wkguest)}
			<div class="form-group">
				<span class="custom-checkbox">
					<label>
						<input type="checkbox" value="1" name="wk-create-account" id="wk-create-account">
						<span><i class="material-icons rtl-no-flip checkbox-checked"></i></span>
						<span>{l s='I also want to create account' mod='wkonepagecheckout'}</span>
					</label>
				</span>
			</div>
		{/if}
		<div class="form-group wkpassword_div {if Configuration::get('WK_CHECKOUT_GUEST_ALLOW')}wkhide{/if}">
			<label class="label-control">{l s='Password' mod='wkonepagecheckout'}</label>
			<input maxlength="60" type="password" name="wk-password" id="wk-password" class="form-control">
			<i class="material-icons wk-check-icon wkhide icon_wk_password">&#xE876;</i>
			<i class="material-icons wk-error-icon wkhide error_wk_password">&#xE001;</i>
			<span id="wk-password-error" class="wkerrorcolor"></span>
		</div>

		{if Configuration::get('WK_CHECKOUT_DOB')}
		<div class="form-group">
			<label class="label-control">{l s='Date of birth' mod='wkonepagecheckout'}</label>
			<div class="row">
				<div class="col-md-4">
					<select name="wk_day" id="wk_day" class="form-control">
						<option value="0">{l s='Day' mod='wkonepagecheckout'}</option>
						{for $day=1 to 31}
							<option value="{$day}">{$day}</option>
						{/for}
					</select>
				</div>
				<div class="col-md-4">
					<select name="wk_month" id="wk_month" class="form-control">
						<option value="0">{l s='Month' mod='wkonepagecheckout'}</option>
						{for $month=1 to 12}
							<option value="{$month}">{$month}</option>
						{/for}
					</select>
				</div>
				<div class="col-md-4">
					<select name="wk_year" id="wk_year" class="form-control">
						<option value="0">{l s='Year' mod='wkonepagecheckout'}</option>
						{for $year=date(Y)-100 to date(Y)}
							<option value="{$year}">{$year}</option>
						{/for}
					</select>
				</div>
			</div>
		</div>
		{/if}

		{if Configuration::get('WK_CHECKOUT_OPTIN')}
		<div class="form-group">
			<span class="custom-checkbox">
				<label>
					<input type="checkbox" value="1" name="wk-optin" id="wk-optin" class="form-control">
					<span><i class="material-icons checkbox-checked"></i></span>
					<span>{l s='Receive offers from our partners' mod='wkonepagecheckout'}</span>
				</label>
			</span>
		</div>
		{/if}

		{if Configuration::get('WK_CHECKOUT_NEWSLATTER')}
		<div class="form-group">
			<span class="custom-checkbox">
				<label>
					<input type="checkbox" value="1" name="wk-newsletter" id="wk-newsletter" class="form-control">
					<span><i class="material-icons checkbox-checked"></i></span>
					<span>{l s='Sign up for our newsletter' mod='wkonepagecheckout'}</span>
				</label>
			</span>
		</div>
		{/if}
	</div>

	{block name='wk-customer-address'}
		{include file='module:wkonepagecheckout/views/templates/front/content/_partials/wk-myaccount.tpl'}
	{/block}
</div>
