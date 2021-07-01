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

{* Adriana - 23/06/2020 - início *}
<script language="JavaScript">
 	/*
	A função Mascara tera como valores no argumento os dados inseridos no input (ou no evento onkeypress)
	onkeypress="mascara(this, '## ####-####')"
	onkeypress = chama uma função quando uma tecla é pressionada, no exemplo acima, chama a função mascara e define os valores do argumento na função
	O primeiro valor é o this, é o Apontador/Indicador da Mascara, o '## ####-####' é o modelo / formato da mascara
	no exemplo acima o # indica os números, e o - (hifen) o caracter que será inserido entre os números, ou seja, no exemplo acima o telefone ficara assim: 11-4000-3562
	para o celular de são paulo o modelo deverá ser assim: '## #####-####' [11 98563-1254]
	para o RG '##.###.###.# [40.123.456.7]
	para o CPF '###.###.###.##' [789.456.123.10]
	Ou seja esta mascara tem como objetivo inserir o hifen ou espaço automáticamente quando o usuário inserir o número do celular, cpf, rg, etc 

	lembrando que o hifen ou qualquer outro caracter é contado tambem, como: 11-4561-6543 temos 10 números e 2 hifens, por isso o valor de maxlength será 12
	<input type="text" name="telefone" onkeypress="mascara(this, '## ####-####')" maxlength="12">
	neste código não é possivel inserir () ou [], apenas . (ponto), - (hifén) ou espaço
	*/
	function mascara(t, mask){
		var i = t.value.length;
		var saida = mask.substring(1,0);
		var texto = mask.substring(i)
		if (texto.substring(0,1) != saida){
			t.value += texto.substring(0,1);
		}
	}
	
    $(function(){
		$("input[name='wk_invoice_address_zip']").on('input', function (e) {
			$(this).val($(this).val().replace(/[^0-9-]/g, ''));
		});
	});

	function retiraHifenPostcodeInvoice() {
		var aux1 = document.getElementById("wk_invoice_address_zip").value;
		var aux2 = aux1.replace('-','');
		document.getElementById("wk_invoice_address_zip").value = aux2;
	}
</script>

<!--Importando Script Jquery-->
<script type="text/javascript" src="https://code.jquery.com/jquery-3.2.1.min.js">
</script>
<script src="https://code.jquery.com/jquery-1.10.0.min.js"></script>
<script src="https://rawgit.com/RobinHerbots/Inputmask/3.x/dist/jquery.inputmask.bundle.js"></script>
{* Adriana - 23/06/2020 - fim *}

<div id="wk-invoice-address-form">
	<div class="wk-invoice-address-form wk_div_container">
		<form method="POST" action="#" id="wk-invoice-form">
			<input type="hidden" name="data-type" value="invoice" id="invoice">
			<input type="hidden" name="id-new-invoice-address" value="{if isset($delivery_address)}{$delivery_address->id}{/if}" id="id-new-invoice-address">

			{if Configuration::get('WK_CHECKOUT_INVOICE_ALIAS_SHOW')}
			<div class="form-group">
				<label class="label-control {if Configuration::get('WK_CHECKOUT_INVOICE_ALIAS_REQ')}required{/if}">{l s='Address Alias' mod='wkonepagecheckout'}
				</label>
				<input
					maxlength="32"
					{if Configuration::get('WK_CHECKOUT_INVOICE_ALIAS_REQ')}data-required="1"{else}data-required="0"{/if}
					data-validate="isGenericName"
					type="text"
					name="wk_invoice_address_alias"
					id="wk_invoice_address_alias"
					value="{if isset($delivery_address)}{$delivery_address->alias}{/if}"
					class="form-control wkvalidatefield">
				<i class="material-icons wk-check-icon wkhide icon_wk_wk_invoice_address_alias">&#xE876;</i>
				<i class="material-icons wk-error-icon wkhide error_wk_wk_invoice_address_alias">&#xE001;</i>
				<span class="help-block wk-error wk_invoice_address_alias"></span>
			</div>
			{/if}

			<div class="form-group">
				<label class="label-control required">{l s='First Name' mod='wkonepagecheckout'}</label>
				<input
					maxlength="32"
					data-required="1"
					data-validate="isName"
					type="text"
					name="wk_invoice_first_name"
					id="wk_invoice_first_name"
					class="form-control wkvalidatefield"
					value="{if isset($delivery_address)}{$delivery_address->firstname}{else}{$customer['firstname']}{/if}">
				<i class="material-icons wk-check-icon wkhide icon_wk_invoice_first_name">&#xE876;</i>
				<i class="material-icons wk-error-icon wkhide error_wk_invoice_first_name">&#xE001;</i>
				<span class="help-block wk-error wk_invoice_first_name"></span>
			</div>

			<div class="form-group">
				<label class="label-control required">{l s='Last Name' mod='wkonepagecheckout'}</label>
				<input
					maxlength="32"
					data-required="1"
					data-validate="isName"
					type="text"
					name="wk_invoice_last_name"
					id="wk_invoice_last_name"
					value="{if isset($delivery_address)}{$delivery_address->lastname}{else}{$customer['lastname']}{/if}"
					class="form-control wkvalidatefield">
				<i class="material-icons wk-check-icon wkhide icon_wk_invoice_last_name">&#xE876;</i>
				<i class="material-icons wk-error-icon wkhide error_wk_invoice_last_name">&#xE001;</i>
				<span class="help-block wk-error wk_invoice_last_name"></span>
			</div>

			{if Configuration::get('WK_CHECKOUT_INVOICE_COMPANY_SHOW')}
			<div class="form-group">
				<label class="label-control {if Configuration::get('WK_CHECKOUT_INVOICE_COMPANY_REQ')}required{/if}">{l s='Company' mod='wkonepagecheckout'}
				</label>
				<input
					maxlength="64"
					{if Configuration::get('WK_CHECKOUT_INVOICE_COMPANY_REQ')}data-required="1"{else}data-required="0"{/if}
					data-validate="isGenericName"
					type="text"
					name="wk_invoice_company_name"
					id="wk_invoice_company_name"
					value="{if isset($delivery_address)}{$delivery_address->company}{else}{$customer.addresses.{$cart.id_address_delivery}.company}{/if}"
					class="form-control wkvalidatefield">
				<i class="material-icons wk-check-icon wkhide icon_wk_invoice_company_name">&#xE876;</i>
				<i class="material-icons wk-error-icon wkhide error_wk_invoice_company_name">&#xE001;</i>
				<span class="help-block wk-error wk_invoice_company_name"></span>
			</div>
			{/if}

			{if Configuration::get('WK_CHECKOUT_INVOICE_DNI_SHOW')}
			<div class="form-group">
				<label class="label-control {if Configuration::get('WK_CHECKOUT_INVOICE_DNI_REQ')}required{/if}">{l s='DNI Number' mod='wkonepagecheckout'}
				</label>
				<input
					{if Configuration::get('WK_CHECKOUT_INVOICE_DNI_REQ')}data-required="1"{else}data-required="0"{/if}
					data-validate="isDniLite"
					type="text"
					name="wk_invoice_dni_info"
					id="wk_invoice_dni_info"
					onblur="validar_dni_invoice()"
                    maxlength="18" placeholder="Informe somente números" 
                    onkeypress="return isNumberKey(event)"
					{* Adriana - 23/06/2020 - fim *}
					value="{if isset($delivery_address)}{$delivery_address->dni}{else}{$customer.addresses.{$cart.id_address_delivery}.dni}{/if}" 
					class="form-control wkvalidatefield wkvalidatefield">
				<i class="material-icons wk-check-icon wkhide icon_wk_invoice_vat_info">&#xE876;</i>
				<i class="material-icons wk-error-icon wkhide error_wk_invoice_vat_info">&#xE001;</i>
				<span class="help-block wk-error wk_invoice_vat_info"></span>
				</div>
			{/if}

			{* Adriana - 23/06/2020 - início *}
			<div class="form-group">
				<label class="label-control required">{l s='Zip/Postal Code' mod='wkonepagecheckout'}</label>
				<input
					data-required="1"
					data-validate="isPostCode"
					type="text"
					name="wk_invoice_address_zip"
					id="wk_invoice_address_zip"
					{* Adriana - 23/06/2020 - início *}
					{* maxlength="12" *}
					maxlength="9"
					{* Adriana - 23/06/2020 - fim *}
					placeholder="Informe somente números"
					onkeypress="return isNumberKey(event)"
					oninvalid="this.setCustomValidity('Informe o CEP.')" 
					onkeyup="setCustomValidity('')" title=" "
					{* Adriana - 23/06/2020 - fim *}	
					value="{if isset($delivery_address)}{$delivery_address->postcode}{/if}"
					class="form-control wkvalidatefield">
				<i class="material-icons wk-check-icon wkhide icon_wk_invoice_address_zip">&#xE876;</i>
				<i class="material-icons wk-error-icon wkhide error_wk_invoice_address_zip">&#xE001;</i>
				<span class="help-block wk-error wk_invoice_address_zip"></span>
			</div>
			{* Adriana - 23/06/2020 - fim *}

			<div class="form-group">
				<label class="label-control required">{l s='Address' mod='wkonepagecheckout'}</label>
				<input
					maxlength="128"
					data-required="1"
					data-validate="isAddress"
					type="text"
					name="wk_invoice_address_info"
					id="wk_invoice_address_info"
					{* Adriana - 23/06/2020 - início *}
					oninvalid="this.setCustomValidity('Informe o endereço.')" 
					onkeyup="setCustomValidity('')" title=" "
					{* Adriana - 23/06/2020 - fim *}
					value="{if isset($delivery_address)}{$delivery_address->address1}{/if}"
					class="form-control wkvalidatefield">
				<i class="material-icons wk-check-icon wkhide icon_wk_invoice_address_info">&#xE876;</i>
				<i class="material-icons wk-error-icon wkhide error_wk_invoice_address_info">&#xE001;</i>
				<span class="help-block wk-error wk_invoice_address_info"></span>
			</div>

			{if Configuration::get('WK_CHECKOUT_INVOICE_NUMBER_SHOW')}
			<div class="form-group">
				<label class="label-control {if Configuration::get('WK_CHECKOUT_INVOICE_NUMBER_REQ')}required{/if}">{l s='Number' mod='wkonepagecheckout'}
				</label>
				<input
					{if Configuration::get('WK_CHECKOUT_INVOICE_NUMBER_REQ')}data-required="1"{else}data-required="0"{/if}
					data-validate="isGenericName"
					type="text"
					name="wk_invoice_address_number"
					id="wk_invoice_address_number"
					value="{if isset($delivery_address)}{$delivery_address->number}{/if}"
					class="form-control wkvalidatefield">
				<i class="material-icons wk-check-icon wkhide icon_wk_invoice_address_number">&#xE876;</i>
				<i class="material-icons wk-error-icon wkhide error_wk_invoice_address_number">&#xE001;</i>
				<span class="help-block wk-error wk_invoice_address_number"></span>
			</div>
			{/if}

			{* Adriana - 15/07/2020 - início *}
			{if Configuration::get('WK_CHECKOUT_INVOICE_OTHER_SHOW')}
			<div class="form-group">
				<label class="label-control {if Configuration::get('WK_CHECKOUT_INVOICE_OTHER_REQ')}required{/if}">{l s='Other Information' mod='wkonepagecheckout'}
				</label>
				<input
					maxlength="300"
					{if Configuration::get('WK_CHECKOUT_INVOICE_OTHER_REQ')}data-required="1"{else}data-required="0"{/if}
					data-validate="isMessage"
					type="text"
					name="wk_invoice_address_other_information"
					id="wk_invoice_address_other_information"
					value="{if isset($delivery_address)}{$delivery_address->other}{/if}"
					class="form-control wkvalidatefield">
				<i class="material-icons wk-check-icon wkhide icon_wk_invoice_address_other_information">&#xE876;</i>
				<i class="material-icons wk-error-icon wkhide error_wk_invoice_address_other_information">&#xE001;</i>
				<span class="help-block wk-error wk_invoice_address_other_information"></span>
			</div>
			{/if}
			{* Adriana - 15/07/2020 - fim *}

            {* Adriana - 15/07/2020 - início *}
            {*
			{if Configuration::get('WK_CHECKOUT_INVOICE_ADDRESS_COMPANY_SHOW')}
			*}
			{if Configuration::get('WK_CHECKOUT_INVOICE_ADDRESS_COMPLEM_SHOW')}
            {* Adriana - 15/07/2020 - fim *}							 
			<div class="form-group">
				{* Adriana - 15/07/2020 - início *}
			    {*
				<label class="label-control {if Configuration::get('WK_CHECKOUT_INVOICE_ADDRESS_COMPANY_REQ')}required{/if}">{l s='Address Complement' mod='wkonepagecheckout'}
				</label>
				*}
				<label class="label-control {if Configuration::get('WK_CHECKOUT_INVOICE_ADDRESS_COMPLEM_REQ')}required{/if}">{l s='Address Complement' mod='wkonepagecheckout'}
				</label>
			    {* Adriana - 15/07/2020 - fim *}
				<input
					maxlength="128"
			        {* Adriana - 15/07/2020 - início *}
					{*
					{if Configuration::get('WK_CHECKOUT_INVOICE_ADDRESS_COMPANY_REQ')}data-required="1"{else}data-required="0"{/if}
					*}
					{if Configuration::get('WK_CHECKOUT_INVOICE_ADDRESS_COMPLEM_REQ')}data-required="1"{else}data-required="0"{/if}
			        {* Adriana - 15/07/2020 - fim *}
					data-validate="isAddress"
					type="text"
					name="wk_invoice_address_complement"
					id="wk_invoice_address_complement"
					value="{if isset($delivery_address)}{$delivery_address->address2}{/if}"
					class="form-control wkvalidatefield">
				<i class="material-icons wk-check-icon wkhide icon_wk_invoice_address_complement">&#xE876;</i>
				<i class="material-icons wk-error-icon wkhide error_wk_invoice_address_complement">&#xE001;</i>
				<span class="help-block wk-error wk_invoice_address_complement"></span>
			</div>
			{/if}
			
			<div class="form-group">
				<label class="label-control required">{l s='City' mod='wkonepagecheckout'}</label>
				<input
					maxlength="64"
					data-required="1"
					data-validate="isCityName"
					type="text"
					name="wk_invoice_address_city"
					id="wk_invoice_address_city"
					{* Adriana - 23/06/2020 - início *}
					oninvalid="this.setCustomValidity('Informe a cidade.')"
					onkeyup="setCustomValidity('')" title=" "
					{* Adriana - 23/06/2020 - fim *}
					value="{if isset($delivery_address)}{$delivery_address->city}{/if}"
					class="form-control wkvalidatefield">
				<i class="material-icons wk-check-icon wkhide icon_wk_invoice_address_city">&#xE876;</i>
				<i class="material-icons wk-error-icon wkhide error_wk_invoice_address_city">&#xE001;</i>
				<span class="help-block wk-error wk_invoice_address_city"></span>
			</div>

			<div id="wk_invoice_address_state">
				{if isset($states) && $states}
					{block name='wk_invoice_address_state'}
						{include file="module:wkonepagecheckout/views/templates/front/content/_partials/wk-invoice-state.tpl"}
					{/block}
				{/if}
			</div>

			<div class="form-group">
				<label class="label-control required">{l s='Country' mod='wkonepagecheckout'}</label>
				<select
					data-required="1"
					data-attr="invoice"
					name="wk_invoice_address_country"
					class="form-control wk_address_country">
					{if isset($countries)}
						{foreach $countries as $country}
							<option
								{if isset($delivery_address)}
									{if $delivery_address->id_country == $country.id_country}selected="selected"{/if}
								{else if isset($cartAddress)}
									{if $cartAddress->id_country == $country.id_country}selected="selected"{/if}
								{else if $defaultCountry == $country.id_country}selected="selected"{/if}
								value="{$country.id_country}">{$country.name}</option>
						{/foreach}
					{/if}
				</select>
			</div>

			{if Configuration::get('WK_CHECKOUT_INVOICE_MOBILE_PHONE_SHOW')}
			<div class="form-group">
				<label class="label-control {if Configuration::get('WK_CHECKOUT_INVOICE_MOBILE_PHONE_REQ')}required{/if}">{l s='Mobile Phone' mod='wkonepagecheckout'}
				</label>
				<input 
					{* Adriana - 23/06/2020 - início *}
					{* maxlength="32" *}
					onkeypress="mascara(this, '## #####-####')" 
					maxlength="13"
					placeholder="Informe somente números"
					onkeypress="return isNumberKey(event)"
					{* Adriana - 23/06/2020 - fim *}										   
					{if Configuration::get('WK_CHECKOUT_INVOICE_MOBILE_PHONE_REQ')}data-required="1"{else}data-required="0"{/if}
					data-validate="isPhoneNumber"
					type="text"
					name="wk_invoice_address_mobile_phone"
					{* Adriana - 23/06/2020 - início *}	
					{* id="wk_invoice_address_mobile_phone"
					value="{if isset($delivery_address)}{$delivery_address->phone_mobile}{/if}" *}
					id="phone_mobile"
					oninvalid="this.setCustomValidity('Informe o número de celular.')" 
					onkeyup="setCustomValidity('')" title=" "
					value="{if isset($delivery_address)}{$delivery_address->phone_mobile}{/if}"
					{* Adriana - 23/06/2020 - fim *}
					class="form-control wkvalidatefield">
				<i class="material-icons wk-check-icon wkhide icon_wk_invoice_address_mobile_phone">&#xE876;</i>
				<i class="material-icons wk-error-icon wkhide error_wk_invoice_address_mobile_phone">&#xE001;</i>
				<span class="help-block wk-error wk_invoice_address_mobile_phone"></span>
			</div>
			{/if}

			{if Configuration::get('WK_CHECKOUT_INVOICE_PHONE_SHOW')}
			<div class="form-group">
				<label class="label-control {if Configuration::get('WK_CHECKOUT_INVOICE_PHONE_REQ')}required{/if}">{l s='Phone' mod='wkonepagecheckout'}
				</label>
				<input
					{* Adriana - 23/06/2020 - início *}
					{* maxlength="32" *}
					onkeypress="mascara(this, '## #####-####')" 
					maxlength="13"
					placeholder="Informe somente números"
					onkeypress="return isNumberKey(event)"
					{* Adriana - 23/06/2020 - fim *}
					{if Configuration::get('WK_CHECKOUT_INVOICE_PHONE_REQ')}data-required="1"{else}data-required="0"{/if}
					data-validate="isPhoneNumber"
					type="text"
					name="wk_invoice_address_phone"
					{* Adriana - 23/06/2020 - início *}			  
					{* id="wk_invoice_address_phone" *}
					id="phone"
					{* Adriana - 23/06/2020 - fim *}
					value="{if isset($delivery_address)}{$delivery_address->phone}{/if}"
					class="form-control wkvalidatefield">
				<i class="material-icons wk-check-icon wkhide icon_wk_invoice_address_phone">&#xE876;</i>
				<i class="material-icons wk-error-icon wkhide error_wk_invoice_address_phone">&#xE001;</i>
				<span class="help-block wk-error wk_invoice_address_phone"></span>
			</div>
			{/if}

			<div class="form-group" style="text-align: right;">
				{* Adriana - 23/06/2020 - início *}
				{* <button data-type="invoice" class="btn btn-primary wk-save-address"> 
					{l s='Save' mod='wkonepagecheckout'} *}
				<button data-type="invoice" class="btn btn-primary wk-save-address" onclick="retiraHifenPostcodeInvoice()">
					{l s='Save' mod='wkonepagecheckout'}
				{* Adriana - 23/06/2020 - fim *}
				<div class="wkhide wk_text-light wkbotton" id="wk-msg-new-invoice"></div>
			</div>
		</form>
	</div>
</div>

{* Adriana - 23/06/2020 - início *}
<script type="text/javascript">
	$("#wk_invoice_address_zip").focusout(function(){
		{* Adriana - 31/05/2021 - início *}
		if ($(this).val() != "") {
		{* Adriana - 31/05/2021 - fim *}
		//Início do Comando AJAX
		$.ajax({
			//O campo URL diz o caminho de onde virá os dados
			//É importante concatenar o valor digitado no CEP
			/* Adriana - 09/09/2020 - início */
			//Resolvendo problema de bloqueio CORS: 
			//Access to XMLHttpRequest at 'https://viacep.com.br/ws/01410-000/json/unicode/' from origin 
			//has been blocked by CORS policy: Request header field x-firephp is not allowed by 
			//Access-Control-Allow-Headers in preflight response.
			//url: 'https://viacep.com.br/ws/'+$(this).val()+'/json/unicode/',
			//url: 'https://cors-anywhere.herokuapp.com/https://viacep.com.br/ws/'+$(this).val()+'/json/unicode/',
			url: 'https://viacep.com.br/ws/'+$(this).val()+'/json/',
			/* Adriana - 09/09/2020 - fim */
			//Aqui você deve preencher o tipo de dados que será lido,
			//no caso, estamos lendo JSON.
			dataType: 'json',
			//SUCCESS é referente a função que será executada caso
			//ele consiga ler a fonte de dados com sucesso.
			//O parâmetro dentro da função se refere ao nome da variável
			//que você vai dar para ler esse objeto.
			success: function(resposta){
				//Agora basta definir os valores que você deseja preencher
				//automaticamente nos campos acima.
				// Adriana - 23/06/2020 - início
				//$("#address1").val(resposta.logradouro);
				//$("#address2").val(resposta.bairro);
				//$("#city").val(resposta.localidade);
				$("#wk_invoice_address_info").val(resposta.logradouro);
				$("#wk_invoice_address_complement").val(resposta.bairro);
				$("#wk_invoice_address_city").val(resposta.localidade);
				// Adriana - 23/06/2020 - fim

                var state = resposta.uf;
                switch (state) {
                    case "AC":
        				$("#id_state").val(325);
                        break;
                    case "AL":
                    	$("#id_state").val(326);
                        break;
                    case "AP":
                    	$("#id_state").val(327);
                        break;
                    case "AM":
                    	$("#id_state").val(328);
                    	break;
                    case "BA":
                    	$("#id_state").val(329);
                    	break;
                    case "CE":
                    	$("#id_state").val(330);
                    	break;
                    case "DF":
                    	$("#id_state").val(331);
                    	break;
                    case "ES":
                    	$("#id_state").val(332);
                    	break;
                    case "GO":
                    	$("#id_state").val(333);
                    	break;
                    case "MA":
                    	$("#id_state").val(334);
                    	break;
                    case "MT":
                    	$("#id_state").val(335);
                    	break;
                    case "MS":
                    	$("#id_state").val(336);
                    	break;
                    case "MG":
                    	$("#id_state").val(337);
                    	break;
                    case "PA":
                    	$("#id_state").val(338);
                    	break;
                    case "PB":
                    	$("#id_state").val(339);
                    	break;
                    case "PR":
                    	$("#id_state").val(340);
                    	break;
                    case "PE":
                    	$("#id_state").val(341);
                    	break;
                    case "PI":
                    	$("#id_state").val(342);
                    	break;
                    case "RJ":
                    	$("#id_state").val(343);
                    	break;
                    case "RN":
                    	$("#id_state").val(344);
                    	break;
                    case "RS":
                    	$("#id_state").val(345);
                    	break;
                    case "RO":
                    	$("#id_state").val(346);
                    	break;
                    case "RR":
                    	$("#id_state").val(347);
                    	break;
                    case "SC":
                    	$("#id_state").val(348);
                    	break;
                    case "SP":
        				$("#id_state").val(349);
                        break;
                    case "SE":
                    	$("#id_state").val(350);
                        break;
                    case "TO":
                    	$("#id_state").val(351);
                        break;
                }

				//Vamos incluir para que o Número seja focado automaticamente
				//melhorando a experiência do usuário
				$("#wk_invoice_address_number").focus();
			}
		});
		{* Adriana - 31/05/2021 - início *}
		}
		{* Adriana - 31/05/2021 - fim *}
	});
</script>

<script>
	if (document.getElementById("wk_invoice_dni_info")){
		document.getElementById("wk_invoice_dni_info").addEventListener("keydown", mascaraDni);
		function mascaraDni() {
		if(event.keyCode != 46 && event.keyCode != 8 && event.keyCode != 9){
			var i = document.getElementById("wk_invoice_dni_info").value.length; //aqui pega o tamanho do input
			if (i === 3 || i === 7) //aqui faz a divisoes colocando um ponto no terceiro e setimo indice
			document.getElementById("wk_invoice_dni_info").value = document.getElementById("wk_invoice_dni_info").value + ".";
			else if (i === 11) //aqui faz a divisao colocando o hífen no decimo primeiro indice
			document.getElementById("wk_invoice_dni_info").value = document.getElementById("wk_invoice_dni_info").value + "-";
			else if (i === 14) 
				var dni_aux = document.getElementById("wk_invoice_dni_info").value;
				if (i === 14 && dni_aux.substr(4, 1) != '.'){
					document.getElementById("wk_invoice_dni_info").value = document.getElementById("wk_invoice_dni_info").value.replace(/[^0-9]/g, '');
					var str = document.getElementById("wk_invoice_dni_info").value;
					var str1 = str.slice(0, 2);
					var str2 = str.slice(2, 5);
					var str3 = str.slice(5, 8);
					var str4 = str.slice(8, 11);
					var res = str1.concat('.'+str2+'.'+str3+'/'+str4);
					document.getElementById("wk_invoice_dni_info").value = res;
				}
			else if (i === 15) //aqui faz a divisao colocando o hífen no decimo quinto indice
			document.getElementById("wk_invoice_dni_info").value = document.getElementById("wk_invoice_dni_info").value + "-";
		}
		}
	}    
</script>

<script>
	if (document.getElementById("wk_invoice_address_zip")){
		document.getElementById("wk_invoice_address_zip").addEventListener("keydown", mascaraPostcode);
		function mascaraPostcode() {
		if(event.keyCode != 46 && event.keyCode != 8 && event.keyCode != 9){
			var i = document.getElementById("wk_invoice_address_zip").value.length; //aqui pega o tamanho do input
			if (i === 5) //aqui faz a divisao colocando o hífen no quinto indice
				document.getElementById("wk_invoice_address_zip").value = document.getElementById("wk_invoice_address_zip").value + "-";
			}
		}
	}
</script>

<script>
{literal}

function validar_dni_invoice()
{
	dni = $('#wk_invoice_dni_info');
	
	dni.closest(".form-group").find('i').remove();
	dni.closest(".form-group").removeClass("has-error");

    //valida
	var dni_aux = $('#wk_invoice_dni_info').val();
	var dni_valido = validarCpfCnpj(dni_aux);
	if (!dni_valido) {
        $('#wk_invoice_dni_info').focus();
        dni.closest(".form-group").addClass("has-error");
		$("<i class='small'><br>Informe um CPF/CNPJ válido!</i>").insertAfter(dni);
	}
	else{
		dni.closest(".form-group").find('i').remove();
		dni.closest(".form-group").removeClass("has-error");
	}
}

function isNumberKey(evt)
{
	var charCode = (evt.which) ? evt.which : event.keyCode
	if (charCode > 31 && (charCode < 48 || charCode > 57)){
		return false;
	}
	return true;
}

function validaCPFInvoice(s) 
{
	var c = s.substr(0,9);
	var dv = s.substr(9,2);
	var d1 = 0;
	for (var i=0; i<9; i++) {
		d1 += c.charAt(i)*(10-i);
 	}
	if (d1 == 0) return false;
	d1 = 11 - (d1 % 11);
	if (d1 > 9) d1 = 0;
	if (dv.charAt(0) != d1){
		return false;
	}
	d1 *= 2;
	for (var i = 0; i < 9; i++)	{
 		d1 += c.charAt(i)*(11-i);
	}
	d1 = 11 - (d1 % 11);
	if (d1 > 9) d1 = 0;
	if (dv.charAt(1) != d1){
		return false;
	}
    return true;
}

function validaCNPJInvoice(CNPJ) 
{
	var a = new Array();
	var b = new Number;
	var c = [6,5,4,3,2,9,8,7,6,5,4,3,2];
	for (i=0; i<12; i++){
		a[i] = CNPJ.charAt(i);
		b += a[i] * c[i+1];
	}
	if ((x = b % 11) < 2) { a[12] = 0 } else { a[12] = 11-x }
	b = 0;
	for (y=0; y<13; y++) {
		b += (a[y] * c[y]);
	}
	if ((x = b % 11) < 2) { a[13] = 0; } else { a[13] = 11-x; }
	if ((CNPJ.charAt(12) != a[12]) || (CNPJ.charAt(13) != a[13])){
		return false;
	}
	return true;
}

function validarCpfCnpj(valor) 
{
	var s = (valor).replace(/\D/g,'');
	var tam=(s).length;
	if (!(tam==11 || tam==14)){
		return false;
	}
	if (tam==11 ){
		if (!validaCPFInvoice(s)){
			return false;
		}
		return true;
	}		
	if (tam==14){
		if(!validaCNPJInvoice(s)){
			return false;			
		}
		return true;
	}
}
{/literal}
</script>
{* Adriana - 23/06/2020 - fim *}
