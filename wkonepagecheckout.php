<?php
/**
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
*/

if (!defined('_PS_VERSION_')) {
    exit;
}

use PrestaShop\PrestaShop\Adapter\Product\PriceFormatter;
/* Adriana - 22/03/2021 - início */
//use PrestaShop\PrestaShop\Adapter\ObjectPresenter;
use PrestaShop\PrestaShop\Adapter\Presenter\Object\ObjectPresenter;
/* Adriana - 22/03/2021 - fim */

include_once 'classes/WkOnePageCheckoutDb.php';
include_once 'classes/wkonepagecheckouthelper.php';
include_once 'classes/wkonepagecheckoutsavecart.php';

class WkOnePageCheckOut extends Module
{
    public function __construct()
    {
        $this->name = 'wkonepagecheckout';
        $this->tab = 'front_office_features';
        $this->version = '4.2.2';
        $this->author = 'Webkul';
        $this->bootstrap = true;
        $this->ps_versions_compliancy = array('min' => '1.7', 'max' => _PS_VERSION_);
        parent::__construct();
        $this->displayName = $this->l('Prestashop One Page Checkout');
        $this->description = $this->l('Complete checkout process on a single page');
    }

    public function hookDisplaycustomerAccount()
    {
        $this->context->smarty->assign(array(
            'wkcheckout_cart_save' => $this->context->link->getModuleLink($this->name, 'wkmycart'),
        ));
        return $this->display(__FILE__, 'wk_checkout_save_cart.tpl');
    }

    public function hookDisplayHeader()
    {
        if (!$this->context->controller->ajax) {
            if ('cart' == Context::getContext()->controller->php_self) {
                if (Configuration::get('WK_CHECKOUT_MODE')) {
                    $valid = false;
                    if (Configuration::get('WK_CHECKOUT_SANDBOX')) {
                        $currentIp = Tools::getRemoteAddr();
                        $whiteIps = Configuration::get('WK_CHECKOUT_IPS');
                        if ($whiteIps) {
                            $whiteIps = explode(',', $whiteIps);
                            foreach ($whiteIps as $ip) {
                                if ($currentIp == $ip) {
                                    $valid = true;
                                    break;
                                }
                            }
                        }
                    }

                    $cart = new Cart((int) $this->context->cart->id);
                    $total_amount = $cart->getOrderTotal(false, Cart::ONLY_PRODUCTS);
                    if (($valid || !Configuration::get('WK_CHECKOUT_SANDBOX'))
                    && !Configuration::get('WK_CHECKOUT_CART_DETAIL')
                    && (Configuration::get('PS_PURCHASE_MINIMUM') <= $total_amount)
                    && !$this->context->controller->errors
                    && $this->context->cart->getProducts()) {
                        Tools::redirect($this->context->link->getPageLink('order'));
                    }
                }
            }
        }
    }

    public function hookModuleRoutes()
    {
        return array(
            'module-wkonepagecheckout-wkcheckout' => array(
                    'controller' => 'wkcheckout',
                    'rule' => 'checkout',
                    'keywords' => array(),
                    'params' => array(
                        'fc' => 'module',
                        'module' => 'wkonepagecheckout',
                        'controller' => 'wkcheckout',
                    ),
            ),
            'module-wkonepagecheckout-wkmycart' => array(
                    'controller' => 'wkmycart',
                    'rule' => 'mycart',
                    'keywords' => array(),
                    'params' => array(
                        'fc' => 'module',
                        'module' => 'wkonepagecheckout',
                        'controller' => 'wkmycart',
                    ),
            ),
        );
    }

    public function getContent()
    {
        $this->_html = '';
        $this->context->controller->addJs(_PS_JS_DIR_.'jquery/plugins/jquery.colorpicker.js');
        $this->context->controller->addJs($this->_path.'views/js/admin/wk_checkout_admin.js');
        $this->context->controller->addCSS($this->_path.'views/css/admin/wk_checkout_admin.css');

        $payments = Module::getPaymentModules();
        if ($payments) {
            foreach ($payments as $key => $payment) {
                $module = Module::getInstanceByName($payment['name']);
                if ($module) {
                    $payments[$key]['displayName'] = $module->displayName;
                }
            }
        }
        $this->context->smarty->assign(array(
            'getGroups' => Group::getGroups($this->context->language->id),
            'configValues' => $this->getConfigFieldsValues(),
            'payment_method' => $payments,
            'cmsCondition' => CMS::getCMSPages($this->context->language->id),
            'ip' => Tools::getRemoteAddr(),
            'self' => dirname(__FILE__),

        ));

        if (Tools::isSubmit('submitGeneralConfig')) {
            $this->submitGeneralConfig();
        }

        if (Tools::isSubmit('submitCustomizer')) {
            $this->submitCustomizer();
        }

        if (Tools::isSubmit('submitLoginRegister')) {
            $this->submitLoginRegister();
        }

        if (Tools::isSubmit('submitDeliveryAddress')) {
            $this->submitDeliveryAddress();
        }

        if (Tools::isSubmit('submitInvoiceAddress')) {
            $this->submitInvoiceAddress();
        }

        if (Tools::isSubmit('submitShipping')) {
            $this->submitShipping();
        }

        if (Tools::isSubmit('submitPayment')) {
            $this->submitPayment();
        }

        if (Tools::isSubmit('submitSocialLogin')) {
            $this->submitSocialLogin();
        }

        if (Tools::isSubmit('submitCart')) {
            $this->submitCart();
        }

        if (!empty($this->_postError)) {
            $this->_html .= $this->displayError($this->_postError);
        }

        $tabActive = Tools::getValue('tab_active');
        if ($tabActive) {
            $this->context->smarty->assign(array(
                'tabActive' => $tabActive,
            ));
        }
        $this->context->smarty->assign(
            array(
                'currentIndex' => AdminController::$currentIndex.'&token='.Tools::getValue('token').
                '&configure='.$this->name.'&tab_module='.$this->tab.'&module_name='.$this->name
            )
        );
        $this->_html .= $this->display(__FILE__, './views/templates/admin/wk-checkout-config.tpl');

        return $this->_html;
    }

    public function submitGeneralConfig()
    {
        $wkCheckoutSandbox = Tools::getValue('wk_checkout_sandbox');
        $wkCheckoutIpAddress = Tools::getValue('wk_checkout_ip_address');
        if ($wkCheckoutSandbox) {
            if ($wkCheckoutIpAddress) {
                $IPs = explode(',', $wkCheckoutIpAddress);
                foreach ($IPs as $ip) {
                    if (!Validate::isIp2Long(ip2long($ip))) {
                        $this->_postError[] =  sprintf($this->l('"%1$s" address is not valid'), $ip);
                    }
                }
            } else {
                $this->_postError[] =  $this->l('IP address is missing');
            }
        }
        if (empty($this->_postError)) {
            Configuration::updateValue('WK_CHECKOUT_MODE', (int)Tools::getValue('wk_checkout_mode'));
            Configuration::updateValue('WK_CHECKOUT_SANDBOX', (int) $wkCheckoutSandbox);
            Configuration::updateValue('WK_CHECKOUT_IPS', $wkCheckoutIpAddress);

            Tools::redirectAdmin(
                $this->context->link->getAdminLink('AdminModules').'&configure='.$this->name.'&tab_module='.$this->tab.
                '&module_name='.$this->name.'&tab_active=general&conf=4'
            );
        } else {
            $this->context->smarty->assign('generalError', 1);
        }
    }

    public function submitCustomizer()
    {
        $fontSize = trim(Tools::getValue('wk_checkout_button_font_size'));
        $buttonColor = trim(Tools::getValue('wk_checkout_button_color'));
        $fontColor = trim(Tools::getValue('wk_checkout_button_font_color'));

        if ($fontSize) {
            if (!Validate::isInt($fontSize)) {
                $this->_postError[] = $this->l('Font size is not valid');
            } elseif ($fontSize < 0) {
                $this->_postError[] = $this->l('Font size must be greater than zero');
            }
        } else {
            $this->_postError[] = $this->l('Font size can not be empty');
        }

        if (!$buttonColor) {
            $this->_postError[] = $this->l('Please select color for checkout button');
        } elseif (!Validate::isColor($buttonColor)) {
            $this->_postError[] = $this->l('Checkout button color is not valid');
        }

        if (!$fontColor) {
            $this->_postError[] = $this->l('Please select color for checkout font');
        } elseif (!Validate::isColor($fontColor)) {
            $this->_postError[] = $this->l('Checkout font color is not valid');
        }

        if (empty($this->_postError)) {
            Configuration::updateValue('WK_CHECKOUT_BUTTON_FONT_SIZE', $fontSize);
            Configuration::updateValue('WK_CHECKOUT_BUTTON_COLOR', $buttonColor);
            Configuration::updateValue('WK_CHECKOUT_BUTTON_FONT_COLOR', $fontColor);
            Configuration::updateValue(
                'WK_CHECKOUT_BUTTON_FONT_FAMILY',
                Tools::getValue('wk_checkout_button_font_family')
            );

            Tools::redirectAdmin(
                $this->context->link->getAdminLink('AdminModules').'&configure='.$this->name.'&tab_module='.$this->tab.
                '&module_name='.$this->name.'&tab_active=customizer&conf=4'
            );
        } else {
            $this->context->smarty->assign('customizerError', 1);
        }
    }

    public function submitLoginRegister()
    {
        /* Adriana - 15/07/2020 - início */
        /*
        if (Tools::getValue('wk_checkout_default_group')) {
            if (!Configuration::get('PS_GUEST_CHECKOUT_ENABLED')) {
                $this->_postError[] = $this->l(
                    'First you need to enable the guest checkout from Preferences -> Orders'
                );
                Configuration::updateValue('WK_CHECKOUT_GUEST_ALLOW', Configuration::get('PS_GUEST_CHECKOUT_ENABLED'));
            }
        }
        */
        /* Adriana - 15/07/2020 - fim */
        if (empty($this->_postError)) {
            Configuration::updateValue('WK_CHECKOUT_GUEST_ALLOW', Tools::getValue('wk_checkout_guest_allow'));
            Configuration::updateValue('WK_CHECKOUT_DEFAULT_GROUP', Tools::getValue('wk_checkout_default_group'));
            Configuration::updateValue(
                'WK_CHECKOUT_SHOW_ADDRESS_BUTTON',
                Tools::getValue('wk_checkout_show_address_button')
            );
            Configuration::updateValue(
                'WK_CHECKOUT_INLINE_VALIDATION',
                Tools::getValue('wk_checkout_inline_validation')
            );
            Configuration::updateValue('WK_CHECKOUT_SOCIAL_TITLE', Tools::getValue('wk_checkout_social_title'));
            Configuration::updateValue('WK_CHECKOUT_DOB', Tools::getValue('wk_checkout_dob'));
            Configuration::updateValue('WK_CHECKOUT_OPTIN', Tools::getValue('wk_checkout_optin'));
            Configuration::updateValue('WK_CHECKOUT_NEWSLATTER', Tools::getValue('wk_checkout_newslatter'));

            Tools::redirectAdmin(
                $this->context->link->getAdminLink('AdminModules').'&configure='.$this->name.'&tab_module='.$this->tab.
                '&module_name='.$this->name.'&tab_active=loginregister&conf=4'
            );
        }
    }

    public function submitDeliveryAddress()
    {
        Configuration::updateValue(
            'WK_CHECKOUT_DELIVERY_AS_INVOICE',
            Tools::getValue('wk_checkout_delivery_as_invoice')
        );

        $wkCheckoutDeliveryCompanyShow = Tools::getValue('wk_checkout_delivery_company_show');
        $wkCheckoutDeliveryCompanyReq = Tools::getValue('wk_checkout_delivery_company_req');
        if ($wkCheckoutDeliveryCompanyReq) {
            Configuration::updateValue('WK_CHECKOUT_DELIVERY_COMPANY_SHOW', 1);
            Configuration::updateValue('WK_CHECKOUT_DELIVERY_COMPANY_REQ', 1);
        } elseif ($wkCheckoutDeliveryCompanyShow) {
            Configuration::updateValue('WK_CHECKOUT_DELIVERY_COMPANY_SHOW', 1);
            Configuration::updateValue('WK_CHECKOUT_DELIVERY_COMPANY_REQ', 0);
        } else {
            Configuration::updateValue('WK_CHECKOUT_DELIVERY_COMPANY_SHOW', 0);
            Configuration::updateValue('WK_CHECKOUT_DELIVERY_COMPANY_REQ', 0);
        }

        $wkCheckoutDeliveryDniShow = Tools::getValue('wk_checkout_delivery_dni_show');
        $wkCheckoutDeliveryDniReq = Tools::getValue('wk_checkout_delivery_dni_req');
        if ($wkCheckoutDeliveryDniReq) {
            Configuration::updateValue('WK_CHECKOUT_DELIVERY_DNI_SHOW', 1);
            Configuration::updateValue('WK_CHECKOUT_DELIVERY_DNI_REQ', 1);
        } elseif ($wkCheckoutDeliveryDniShow) {
            Configuration::updateValue('WK_CHECKOUT_DELIVERY_DNI_SHOW', 1);
            Configuration::updateValue('WK_CHECKOUT_DELIVERY_DNI_REQ', 0);
        } else {
            Configuration::updateValue('WK_CHECKOUT_DELIVERY_DNI_SHOW', 0);
            Configuration::updateValue('WK_CHECKOUT_DELIVERY_DNI_REQ', 0);
        }

        $wkCheckoutDeliveryNumberShow = Tools::getValue('wk_checkout_delivery_number_show');
        $wkCheckoutDeliveryNumberReq = Tools::getValue('wk_checkout_delivery_number_req');
        if ($wkCheckoutDeliveryNumberReq) {
            Configuration::updateValue('WK_CHECKOUT_DELIVERY_NUMBER_SHOW', 1);
            Configuration::updateValue('WK_CHECKOUT_DELIVERY_NUMBER_REQ', 1);
        } elseif ($wkCheckoutDeliveryNumberShow) {
            Configuration::updateValue('WK_CHECKOUT_DELIVERY_NUMBER_SHOW', 1);
            Configuration::updateValue('WK_CHECKOUT_DELIVERY_NUMBER_REQ', 0);
        } else {
            Configuration::updateValue('WK_CHECKOUT_DELIVERY_NUMBER_SHOW', 0);
            Configuration::updateValue('WK_CHECKOUT_DELIVERY_NUMBER_REQ', 0);
        }

        $wkCheckoutDeliveryAddCompShow = Tools::getValue('wk_checkout_delivery_add_comp_show');
        $wkCheckoutDeliveryAddCompReq = Tools::getValue('wk_checkout_delivery_add_comp_req');
        if ($wkCheckoutDeliveryAddCompReq) {
            Configuration::updateValue('WK_CHECKOUT_DELIVERY_ADDRESS_COMPLEM_SHOW', 1);
            Configuration::updateValue('WK_CHECKOUT_DELIVERY_ADDRESS_COMPLEM_REQ', 1);
        } elseif ($wkCheckoutDeliveryAddCompShow) {
            Configuration::updateValue('WK_CHECKOUT_DELIVERY_ADDRESS_COMPLEM_SHOW', 1);
            Configuration::updateValue('WK_CHECKOUT_DELIVERY_ADDRESS_COMPLEM_REQ', 0);
        } else {
            Configuration::updateValue('WK_CHECKOUT_DELIVERY_ADDRESS_COMPLEM_SHOW', 0);
            Configuration::updateValue('WK_CHECKOUT_DELIVERY_ADDRESS_COMPLEM_REQ', 0);
        }

        $wkCheckoutDeliveryPhoneShow = Tools::getValue('wk_checkout_delivery_phone_show');
        $wkCheckoutDeliveryPhoneReq = Tools::getValue('wk_checkout_delivery_phone_req');
        if ($wkCheckoutDeliveryPhoneReq) {
            Configuration::updateValue('WK_CHECKOUT_DELIVERY_PHONE_SHOW', 1);
            Configuration::updateValue('WK_CHECKOUT_DELIVERY_PHONE_REQ', 1);
        } elseif ($wkCheckoutDeliveryPhoneShow) {
            Configuration::updateValue('WK_CHECKOUT_DELIVERY_PHONE_SHOW', 1);
            Configuration::updateValue('WK_CHECKOUT_DELIVERY_PHONE_REQ', 0);
        } else {
            Configuration::updateValue('WK_CHECKOUT_DELIVERY_PHONE_SHOW', 0);
            Configuration::updateValue('WK_CHECKOUT_DELIVERY_PHONE_REQ', 0);
        }

        $wkCheckoutDeliveryMobilePhoneShow = Tools::getValue('wk_checkout_delivery_mobile_phone_show');
        $wkCheckoutDeliveryMobilePhoneReq = Tools::getValue('wk_checkout_delivery_mobile_phone_req');
        if ($wkCheckoutDeliveryMobilePhoneReq) {
            Configuration::updateValue('WK_CHECKOUT_DELIVERY_MOBILE_PHONE_SHOW', 1);
            Configuration::updateValue('WK_CHECKOUT_DELIVERY_MOBILE_PHONE_REQ', 1);
        } elseif ($wkCheckoutDeliveryMobilePhoneShow) {
            Configuration::updateValue('WK_CHECKOUT_DELIVERY_MOBILE_PHONE_SHOW', 1);
            Configuration::updateValue('WK_CHECKOUT_DELIVERY_MOBILE_PHONE_REQ', 0);
        } else {
            Configuration::updateValue('WK_CHECKOUT_DELIVERY_MOBILE_PHONE_SHOW', 0);
            Configuration::updateValue('WK_CHECKOUT_DELIVERY_MOBILE_PHONE_REQ', 0);
        }

        $wkCheckoutDeliveryOtherShow = Tools::getValue('wk_checkout_delivery_other_show');
        $wkCheckoutDeliveryOtherReq = Tools::getValue('wk_checkout_delivery_other_req');
        if ($wkCheckoutDeliveryOtherReq) {
            Configuration::updateValue('WK_CHECKOUT_DELIVERY_OTHER_SHOW', 1);
            Configuration::updateValue('WK_CHECKOUT_DELIVERY_OTHER_REQ', 1);
        } elseif ($wkCheckoutDeliveryOtherShow) {
            Configuration::updateValue('WK_CHECKOUT_DELIVERY_OTHER_SHOW', 1);
            Configuration::updateValue('WK_CHECKOUT_DELIVERY_OTHER_REQ', 0);
        } else {
            Configuration::updateValue('WK_CHECKOUT_DELIVERY_OTHER_SHOW', 0);
            Configuration::updateValue('WK_CHECKOUT_DELIVERY_OTHER_REQ', 0);
        }

        $wkCheckoutDeliveryAliasShow = Tools::getValue('wk_checkout_delivery_alias_show');
        $wkCheckoutDeliveryAliasReq = Tools::getValue('wk_checkout_delivery_alias_req');
        if ($wkCheckoutDeliveryAliasReq) {
            Configuration::updateValue('WK_CHECKOUT_DELIVERY_ALIAS_SHOW', 1);
            Configuration::updateValue('WK_CHECKOUT_DELIVERY_ALIAS_REQ', 1);
        } elseif ($wkCheckoutDeliveryAliasShow) {
            Configuration::updateValue('WK_CHECKOUT_DELIVERY_ALIAS_SHOW', 1);
            Configuration::updateValue('WK_CHECKOUT_DELIVERY_ALIAS_REQ', 0);
        } else {
            Configuration::updateValue('WK_CHECKOUT_DELIVERY_ALIAS_SHOW', 0);
            Configuration::updateValue('WK_CHECKOUT_DELIVERY_ALIAS_REQ', 0);
        }

        Tools::redirectAdmin(
            $this->context->link->getAdminLink('AdminModules').'&configure='.$this->name.'&tab_module='.$this->tab.
            '&module_name='.$this->name.'&tab_active=address&conf=4'
        );
    }

    public function submitInvoiceAddress()
    {
        $wkCheckoutInvoiceCompanyShow = Tools::getValue('wk_checkout_invoice_company_show');
        $wkCheckoutInvoiceCompanyReq = Tools::getValue('wk_checkout_invoice_company_req');
        if ($wkCheckoutInvoiceCompanyReq) {
            Configuration::updateValue('WK_CHECKOUT_INVOICE_COMPANY_SHOW', 1);
            Configuration::updateValue('WK_CHECKOUT_INVOICE_COMPANY_REQ', 1);
        } elseif ($wkCheckoutInvoiceCompanyShow) {
            Configuration::updateValue('WK_CHECKOUT_INVOICE_COMPANY_SHOW', 1);
            Configuration::updateValue('WK_CHECKOUT_INVOICE_COMPANY_REQ', 0);
        } else {
            Configuration::updateValue('WK_CHECKOUT_INVOICE_COMPANY_SHOW', 0);
            Configuration::updateValue('WK_CHECKOUT_INVOICE_COMPANY_REQ', 0);
        }

        $wkCheckoutInvoiceDniShow = Tools::getValue('wk_checkout_invoice_dni_show');
        $wkCheckoutInvoiceDniReq = Tools::getValue('wk_checkout_invoice_dni_req');
        if ($wkCheckoutInvoiceDniReq) {
            Configuration::updateValue('WK_CHECKOUT_INVOICE_DNI_SHOW', 1);
            Configuration::updateValue('WK_CHECKOUT_INVOICE_DNI_REQ', 1);
        } elseif ($wkCheckoutInvoiceDniShow) {
            Configuration::updateValue('WK_CHECKOUT_INVOICE_DNI_SHOW', 1);
            Configuration::updateValue('WK_CHECKOUT_INVOICE_DNI_REQ', 0);
        } else {
            Configuration::updateValue('WK_CHECKOUT_INVOICE_DNI_SHOW', 0);
            Configuration::updateValue('WK_CHECKOUT_INVOICE_DNI_REQ', 0);
        }

        $wkCheckoutInvoiceNumberShow = Tools::getValue('wk_checkout_invoice_number_show');
        $wkCheckoutInvoiceNumberReq = Tools::getValue('wk_checkout_invoice_number_req');
        if ($wkCheckoutInvoiceNumberReq) {
            Configuration::updateValue('WK_CHECKOUT_INVOICE_NUMBER_SHOW', 1);
            Configuration::updateValue('WK_CHECKOUT_INVOICE_NUMBER_REQ', 1);
        } elseif ($wkCheckoutInvoiceNumberShow) {
            Configuration::updateValue('WK_CHECKOUT_INVOICE_NUMBER_SHOW', 1);
            Configuration::updateValue('WK_CHECKOUT_INVOICE_NUMBER_REQ', 0);
        } else {
            Configuration::updateValue('WK_CHECKOUT_INVOICE_NUMBER_SHOW', 0);
            Configuration::updateValue('WK_CHECKOUT_INVOICE_NUMBER_REQ', 0);
        }

        $wkCheckoutInvoiceAddCompShow = Tools::getValue('wk_checkout_invoice_add_comp_show');
        $wkCheckoutInvoiceAddCompReq = Tools::getValue('wk_checkout_invoice_add_comp_req');
        if ($wkCheckoutInvoiceAddCompReq) {
            Configuration::updateValue('WK_CHECKOUT_INVOICE_ADDRESS_COMPLEM_SHOW', 1);
            Configuration::updateValue('WK_CHECKOUT_INVOICE_ADDRESS_COMPLEM_REQ', 1);
        } elseif ($wkCheckoutInvoiceAddCompShow) {
            Configuration::updateValue('WK_CHECKOUT_INVOICE_ADDRESS_COMPLEM_SHOW', 1);
            Configuration::updateValue('WK_CHECKOUT_INVOICE_ADDRESS_COMPLEM_REQ', 0);
        } else {
            Configuration::updateValue('WK_CHECKOUT_INVOICE_ADDRESS_COMPLEM_SHOW', 0);
            Configuration::updateValue('WK_CHECKOUT_INVOICE_ADDRESS_COMPLEM_REQ', 0);
        }

        $wkCheckoutInvoicePhoneShow = Tools::getValue('wk_checkout_invoice_phone_show');
        $wkCheckoutInvoicePhoneReq = Tools::getValue('wk_checkout_invoice_phone_req');
        if ($wkCheckoutInvoicePhoneReq) {
            Configuration::updateValue('WK_CHECKOUT_INVOICE_PHONE_SHOW', 1);
            Configuration::updateValue('WK_CHECKOUT_INVOICE_PHONE_REQ', 1);
        } elseif ($wkCheckoutInvoicePhoneShow) {
            Configuration::updateValue('WK_CHECKOUT_INVOICE_PHONE_SHOW', 1);
            Configuration::updateValue('WK_CHECKOUT_INVOICE_PHONE_REQ', 0);
        } else {
            Configuration::updateValue('WK_CHECKOUT_INVOICE_PHONE_SHOW', 0);
            Configuration::updateValue('WK_CHECKOUT_INVOICE_PHONE_REQ', 0);
        }

        $wkCheckoutInvoiceMobilePhoneShow = Tools::getValue('wk_checkout_invoice_mobile_phone_show');
        $wkCheckoutInvoiceMobilePhoneReq = Tools::getValue('wk_checkout_invoice_mobile_phone_req');
        if ($wkCheckoutInvoiceMobilePhoneReq) {
            Configuration::updateValue('WK_CHECKOUT_INVOICE_MOBILE_PHONE_SHOW', 1);
            Configuration::updateValue('WK_CHECKOUT_INVOICE_MOBILE_PHONE_REQ', 1);
        } elseif ($wkCheckoutInvoiceMobilePhoneShow) {
            Configuration::updateValue('WK_CHECKOUT_INVOICE_MOBILE_PHONE_SHOW', 1);
            Configuration::updateValue('WK_CHECKOUT_INVOICE_MOBILE_PHONE_REQ', 0);
        } else {
            Configuration::updateValue('WK_CHECKOUT_INVOICE_MOBILE_PHONE_SHOW', 0);
            Configuration::updateValue('WK_CHECKOUT_INVOICE_MOBILE_PHONE_REQ', 0);
        }

        $wkCheckoutInvoiceOtherShow = Tools::getValue('wk_checkout_invoice_other_show');
        $wkCheckoutInvoiceOtherReq = Tools::getValue('wk_checkout_invoice_other_req');
        if ($wkCheckoutInvoiceOtherReq) {
            Configuration::updateValue('WK_CHECKOUT_INVOICE_OTHER_SHOW', 1);
            Configuration::updateValue('WK_CHECKOUT_INVOICE_OTHER_REQ', 1);
        } elseif ($wkCheckoutInvoiceOtherShow) {
            Configuration::updateValue('WK_CHECKOUT_INVOICE_OTHER_SHOW', 1);
            Configuration::updateValue('WK_CHECKOUT_INVOICE_OTHER_REQ', 0);
        } else {
            Configuration::updateValue('WK_CHECKOUT_INVOICE_OTHER_SHOW', 0);
            Configuration::updateValue('WK_CHECKOUT_INVOICE_OTHER_REQ', 0);
        }

        $wkCheckoutInvoiceAliasShow = Tools::getValue('wk_checkout_invoice_alias_show');
        $wkCheckoutInvoiceAliasReq = Tools::getValue('wk_checkout_invoice_alias_req');
        if ($wkCheckoutInvoiceAliasReq) {
            Configuration::updateValue('WK_CHECKOUT_INVOICE_ALIAS_SHOW', 1);
            Configuration::updateValue('WK_CHECKOUT_INVOICE_ALIAS_REQ', 1);
        } elseif ($wkCheckoutInvoiceAliasShow) {
            Configuration::updateValue('WK_CHECKOUT_INVOICE_ALIAS_SHOW', 1);
            Configuration::updateValue('WK_CHECKOUT_INVOICE_ALIAS_REQ', 0);
        } else {
            Configuration::updateValue('WK_CHECKOUT_INVOICE_ALIAS_SHOW', 0);
            Configuration::updateValue('WK_CHECKOUT_INVOICE_ALIAS_REQ', 0);
        }

        Tools::redirectAdmin(
            $this->context->link->getAdminLink('AdminModules').'&configure='.$this->name.'&tab_module='.$this->tab.
            '&module_name='.$this->name.'&tab_active=address&conf=4'
        );
    }

    public function submitShipping()
    {
        Configuration::updateValue('WK_CHECKOUT_CARRIER_LOGO', Tools::getValue('wk_checkout_carrier_logo'));
        Configuration::updateValue('WK_CHECKOUT_CARRIER_DESC', Tools::getValue('wk_checkout_carrier_desc'));

        Tools::redirectAdmin(
            $this->context->link->getAdminLink('AdminModules').'&configure='.$this->name.'&tab_module='.$this->tab.
            '&module_name='.$this->name.'&tab_active=shipping&conf=4'
        );
    }

    public function submitPayment()
    {
        Configuration::updateValue('WK_CHECKOUT_PAYMENT_LOGO', Tools::getValue('wk_checkout_payment_logo'));
        Configuration::updateValue('WK_CHECKOUT_DEFAULT_PAYMENT', Tools::getValue('wk_checkout_default_payment'));

        Tools::redirectAdmin(
            $this->context->link->getAdminLink('AdminModules').'&configure='.$this->name.'&tab_module='.$this->tab.
            '&module_name='.$this->name.'&tab_active=payment&conf=4'
        );
    }

    public function submitSocialLogin()
    {
        if (Tools::getValue('wk_checkout_social_login')) {
            Configuration::updateValue('WK_CHECKOUT_SOCIAL_LOGIN', 1);
            if (Tools::getValue('wk_checkout_facebook_login')) {
                $wkFbAppId = Tools::getValue('wk_checkout_fb_app_id');
                $wkFbSecretId = Tools::getValue('wk_checkout_fb_secret_key');
                if ($this->validateFacebookKey($wkFbAppId, $wkFbSecretId)) {
                    Configuration::updateValue('WK_CHECKOUT_FACEBOOK_LOGIN', 1);
                    Configuration::updateValue('WK_CHECKOUT_FB_APP_ID', $wkFbAppId);
                    Configuration::updateValue('WK_CHECKOUT_FB_SECRET_KEY', $wkFbSecretId);
                } else {
                    $this->_postError[] = $this->l('Facebook keys are not valid');
                }
            } else {
                Configuration::updateValue('WK_CHECKOUT_FACEBOOK_LOGIN', 0);
            }

            if (Tools::getValue('wk_checkout_google_login')) {
                $wkGoogleAppKey = Tools::getValue('wk_checkout_google_app_key');
                $wkGoogleSecretKey = Tools::getValue('wk_checkout_google_secret_key');
                if ($wkGoogleAppKey && $wkGoogleSecretKey) {
                    Configuration::updateValue('WK_CHECKOUT_GOOGLE_LOGIN', 1);
                    Configuration::updateValue('WK_CHECKOUT_GOOGLE_APP_KEY', $wkGoogleAppKey);
                    Configuration::updateValue('WK_CHECKOUT_GOOGLE_SECRET_KEY', $wkGoogleSecretKey);
                } else {
                    $this->_postError[] = $this->l('Please enter google key and secret key');
                }
            } else {
                Configuration::updateValue('WK_CHECKOUT_GOOGLE_LOGIN', 0);
            }
        } else {
            Configuration::updateValue('WK_CHECKOUT_SOCIAL_LOGIN', 0);
        }

        if (empty($this->_postError)) {
            Tools::redirectAdmin(
                $this->context->link->getAdminLink('AdminModules').'&configure='.$this->name.'&tab_module='.$this->tab.
                '&module_name='.$this->name.'&tab_active=sociallogin&conf=4'
            );
        } else {
            $this->context->smarty->assign('socialError', 1);
        }
    }

    public function validateFacebookKey($appId, $secretId)
    {
        $link = 'https://graph.facebook.com/'.$appId.'?fields=roles&access_token='.$appId.'|'.$secretId;
        $req = curl_init($link);
        curl_setopt($req, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($req, CURLOPT_POST, true);
        curl_setopt($req, CURLOPT_POSTFIELDS, http_build_query(array()));
        $responseJSON = curl_exec($req);
        $resp = Tools::jsonDecode($responseJSON, true);
        if ((array_key_exists('success', $resp) && $resp['success'] == 1) || isset($resp['id'])) {
            return true;
        }

        return false;
    }

    public function submitCart()
    {
        if (Tools::getValue('wk_checkout_cart_also_bought')) {
            if (!trim(Tools::getValue('wk_checkout_also_bought_number'))) {
                $this->_postError[] = $this->l('Please set number of products to be displayed');
            } elseif (!Validate::isUnsignedInt(Tools::getValue('wk_checkout_also_bought_number'))) {
                $this->_postError[] = $this->l('Please set valid input');
            }
        }
        if (empty($this->_postError)) {
            Configuration::updateValue('WK_CHECKOUT_CART_DETAIL', Tools::getValue('wk_checkout_cart_detail'));
            Configuration::updateValue('WK_CHECKOUT_CART_SAVE_LATER', Tools::getValue('wk_checkout_cart_save_later'));
            Configuration::updateValue('WK_CHECKOUT_CART_ALSO_BOUGHT', Tools::getValue('wk_checkout_cart_also_bought'));
            Configuration::updateValue(
                'WK_CHECKOUT_ALSO_BOUGHT_NUMBER',
                Tools::getValue('wk_checkout_also_bought_number')
            );
            Configuration::updateValue('WK_CHECKOUT_PRODUCT_IMAGE', Tools::getValue('wk_checkout_product_image'));
            if (Tools::getValue('wk_checkout_terms_service')) {
                if (Tools::getValue('wk_checkout_terms_option')) {
                    Configuration::updateValue(
                        'WK_CHECKOUT_TERMS_SERVICE',
                        Tools::getValue('wk_checkout_terms_service')
                    );
                    Configuration::updateValue('WK_CHECKOUT_TERMS_OPTION', Tools::getValue('wk_checkout_terms_option'));

                    // update in prestashop
                    Configuration::updateValue('PS_CONDITIONS', Tools::getValue('wk_checkout_terms_service'));
                    Configuration::updateValue('PS_CONDITIONS_CMS_ID', Tools::getValue('wk_checkout_terms_option'));
                } else {
                    $this->_postError[] = $this->l('Please choose terms and service');
                }
            } else {
                Configuration::updateValue('WK_CHECKOUT_TERMS_SERVICE', 0);
                Configuration::updateValue('PS_CONDITIONS', 0);
            }

            if (empty($this->_postError)) {
                Tools::redirectAdmin(
                    $this->context->link->getAdminLink('AdminModules').'&configure='.$this->name.'&tab_module='.
                    $this->tab.'&module_name='.$this->name.'&tab_active=cart&conf=4'
                );
            } else {
                $this->context->smarty->assign('cartError', 1);
            }
        } else {
            $this->context->smarty->assign('cartError', 1);
        }
    }

    public function getConfigFieldsValues()
    {
        return array(

            // Get general configuration values
            'WK_CHECKOUT_IPS' => Tools::getValue('wk_checkout_ip_address', Configuration::get('WK_CHECKOUT_IPS')),
            'WK_CHECKOUT_MODE' => Tools::getValue('wk_checkout_mode', Configuration::get('WK_CHECKOUT_MODE')),
            'WK_CHECKOUT_SANDBOX' => Tools::getValue('wk_checkout_sandbox', Configuration::get('WK_CHECKOUT_SANDBOX')),

            // Get customizer configuration values
            'WK_CHECKOUT_BUTTON_COLOR' => Tools::getValue(
                'wk_checkout_sandbox',
                Configuration::get('WK_CHECKOUT_BUTTON_COLOR')
            ),
            'WK_CHECKOUT_BUTTON_FONT_SIZE' => Tools::getValue(
                'wk_checkout_button_font_size',
                Configuration::get('WK_CHECKOUT_BUTTON_FONT_SIZE')
            ),
            'WK_CHECKOUT_BUTTON_FONT_COLOR' => Tools::getValue(
                'wk_checkout_button_font_color',
                Configuration::get('WK_CHECKOUT_BUTTON_FONT_COLOR')
            ),
            'WK_CHECKOUT_BUTTON_FONT_FAMILY' => Tools::getValue(
                'wk_checkout_button_font_family',
                Configuration::get('WK_CHECKOUT_BUTTON_FONT_FAMILY')
            ),

            // Get login and registration configuration values
            'WK_CHECKOUT_GUEST_ALLOW' => Tools::getValue(
                'wk_checkout_guest_allow',
                Configuration::get('WK_CHECKOUT_GUEST_ALLOW')
            ),
            'WK_CHECKOUT_DEFAULT_GROUP' => Tools::getValue(
                'wk_checkout_default_group',
                Configuration::get('WK_CHECKOUT_DEFAULT_GROUP')
            ),
            'WK_CHECKOUT_SHOW_ADDRESS_BUTTON' => Tools::getValue(
                'wk_checkout_show_address_button',
                Configuration::get('WK_CHECKOUT_SHOW_ADDRESS_BUTTON')
            ),
            'WK_CHECKOUT_INLINE_VALIDATION' => Tools::getValue(
                'wk_checkout_inline_validation',
                Configuration::get('WK_CHECKOUT_INLINE_VALIDATION')
            ),
            'WK_CHECKOUT_SOCIAL_TITLE' => Tools::getValue(
                'wk_checkout_social_title',
                Configuration::get('WK_CHECKOUT_SOCIAL_TITLE')
            ),
            'WK_CHECKOUT_DOB' => Tools::getValue('wk_checkout_dob', Configuration::get('WK_CHECKOUT_DOB')),
            'WK_CHECKOUT_OPTIN' => Tools::getValue('wk_checkout_optin', Configuration::get('WK_CHECKOUT_OPTIN')),
            'WK_CHECKOUT_NEWSLATTER' => Tools::getValue(
                'wk_checkout_newslatter',
                Configuration::get('WK_CHECKOUT_NEWSLATTER')
            ),

            // Get delivery address configuration values
            'WK_CHECKOUT_DELIVERY_AS_INVOICE' => Tools::getValue(
                'wk_checkout_delivery_as_invoice',
                Configuration::get('WK_CHECKOUT_DELIVERY_AS_INVOICE')
            ),

            'WK_CHECKOUT_DELIVERY_COMPANY_SHOW' => Tools::getValue(
                'wk_checkout_delivery_company_show',
                Configuration::get('WK_CHECKOUT_DELIVERY_COMPANY_SHOW')
            ),
            'WK_CHECKOUT_DELIVERY_COMPANY_REQ' => Tools::getValue(
                'wk_checkout_delivery_company_req',
                Configuration::get('WK_CHECKOUT_DELIVERY_COMPANY_REQ')
            ),

            'WK_CHECKOUT_DELIVERY_DNI_SHOW' => Tools::getValue(
                'wk_checkout_delivery_dni_show',
                Configuration::get('WK_CHECKOUT_DELIVERY_DNI_SHOW')
            ),
            'WK_CHECKOUT_DELIVERY_DNI_REQ' => Tools::getValue(
                'wk_checkout_delivery_dni_req',
                Configuration::get('WK_CHECKOUT_DELIVERY_DNI_REQ')
            ),

            'WK_CHECKOUT_DELIVERY_NUMBER_SHOW' => Tools::getValue(
                'wk_checkout_delivery_number_show',
                Configuration::get('WK_CHECKOUT_DELIVERY_NUMBER_SHOW')
            ),
            'WK_CHECKOUT_DELIVERY_NUMBER_REQ' => Tools::getValue(
                'wk_checkout_delivery_number_req',
                Configuration::get('WK_CHECKOUT_DELIVERY_NUMBER_REQ')
            ),

            'WK_CHECKOUT_DELIVERY_ADDRESS_COMPLEM_SHOW' => Tools::getValue(
                'wk_checkout_delivery_add_comp_show',
                Configuration::get('WK_CHECKOUT_DELIVERY_ADDRESS_COMPLEM_SHOW')
            ),
            'WK_CHECKOUT_DELIVERY_ADDRESS_COMPLEM_REQ' => Tools::getValue(
                'wk_checkout_delivery_add_comp_req',
                Configuration::get('WK_CHECKOUT_DELIVERY_ADDRESS_COMPLEM_REQ')
            ),

            'WK_CHECKOUT_DELIVERY_PHONE_SHOW' => Tools::getValue(
                'wk_checkout_delivery_phone_show',
                Configuration::get('WK_CHECKOUT_DELIVERY_PHONE_SHOW')
            ),
            'WK_CHECKOUT_DELIVERY_PHONE_REQ' => Tools::getValue(
                'wk_checkout_delivery_phone_req',
                Configuration::get('WK_CHECKOUT_DELIVERY_PHONE_REQ')
            ),

            'WK_CHECKOUT_DELIVERY_MOBILE_PHONE_SHOW' => Tools::getValue(
                'wk_checkout_delivery_mobile_phone_show',
                Configuration::get('WK_CHECKOUT_DELIVERY_MOBILE_PHONE_SHOW')
            ),
            'WK_CHECKOUT_DELIVERY_MOBILE_PHONE_REQ' => Tools::getValue(
                'wk_checkout_delivery_mobile_phone_req',
                Configuration::get('WK_CHECKOUT_DELIVERY_MOBILE_PHONE_REQ')
            ),

            'WK_CHECKOUT_DELIVERY_OTHER_SHOW' => Tools::getValue(
                'wk_checkout_delivery_other_show',
                Configuration::get('WK_CHECKOUT_DELIVERY_OTHER_SHOW')
            ),
            'WK_CHECKOUT_DELIVERY_OTHER_REQ' => Tools::getValue(
                'wk_checkout_delivery_other_req',
                Configuration::get('WK_CHECKOUT_DELIVERY_OTHER_REQ')
            ),

            'WK_CHECKOUT_DELIVERY_ALIAS_SHOW' => Tools::getValue(
                'wk_checkout_delivery_alias_show',
                Configuration::get('WK_CHECKOUT_DELIVERY_ALIAS_SHOW')
            ),
            'WK_CHECKOUT_DELIVERY_ALIAS_REQ' => Tools::getValue(
                'wk_checkout_delivery_alias_req',
                Configuration::get('WK_CHECKOUT_DELIVERY_ALIAS_REQ')
            ),

            // Get invoice address configuration values
            'WK_CHECKOUT_INVOICE_COMPANY_SHOW' => Tools::getValue(
                'wk_checkout_invoice_company_show',
                Configuration::get('WK_CHECKOUT_INVOICE_COMPANY_SHOW')
            ),
            'WK_CHECKOUT_INVOICE_COMPANY_REQ' => Tools::getValue(
                'wk_checkout_invoice_company_req',
                Configuration::get('WK_CHECKOUT_INVOICE_COMPANY_REQ')
            ),

            'WK_CHECKOUT_INVOICE_DNI_SHOW' => Tools::getValue(
                'wk_checkout_invoice_dni_show',
                Configuration::get('WK_CHECKOUT_INVOICE_DNI_SHOW')
            ),
            'WK_CHECKOUT_INVOICE_DNI_REQ' => Tools::getValue(
                'wk_checkout_invoice_dni_req',
                Configuration::get('WK_CHECKOUT_INVOICE_DNI_REQ')
            ),

            'WK_CHECKOUT_INVOICE_NUMBER_SHOW' => Tools::getValue(
                'wk_checkout_invoice_number_show',
                Configuration::get('WK_CHECKOUT_INVOICE_NUMBER_SHOW')
            ),
            'WK_CHECKOUT_INVOICE_NUMBER_REQ' => Tools::getValue(
                'wk_checkout_invoice_number_req',
                Configuration::get('WK_CHECKOUT_INVOICE_NUMBER_REQ')
            ),

            'WK_CHECKOUT_INVOICE_ADDRESS_COMPLEM_SHOW' => Tools::getValue(
                'wk_checkout_invoice_add_comp_show',
                Configuration::get('WK_CHECKOUT_INVOICE_ADDRESS_COMPLEM_SHOW')
            ),
            'WK_CHECKOUT_INVOICE_ADDRESS_COMPLEM_REQ' => Tools::getValue(
                'wk_checkout_invoice_add_comp_req',
                Configuration::get('WK_CHECKOUT_INVOICE_ADDRESS_COMPLEM_REQ')
            ),

            'WK_CHECKOUT_INVOICE_PHONE_SHOW' => Tools::getValue(
                'wk_checkout_invoice_phone_show',
                Configuration::get('WK_CHECKOUT_INVOICE_PHONE_SHOW')
            ),
            'WK_CHECKOUT_INVOICE_PHONE_REQ' => Tools::getValue(
                'wk_checkout_invoice_phone_req',
                Configuration::get('WK_CHECKOUT_INVOICE_PHONE_REQ')
            ),

            'WK_CHECKOUT_INVOICE_MOBILE_PHONE_SHOW' => Tools::getValue(
                'wk_checkout_invoice_mobile_phone_show',
                Configuration::get('WK_CHECKOUT_INVOICE_MOBILE_PHONE_SHOW')
            ),
            'WK_CHECKOUT_INVOICE_MOBILE_PHONE_REQ' => Tools::getValue(
                'wk_checkout_invoice_mobile_phone_req',
                Configuration::get('WK_CHECKOUT_INVOICE_MOBILE_PHONE_REQ')
            ),

            'WK_CHECKOUT_INVOICE_OTHER_SHOW' => Tools::getValue(
                'wk_checkout_invoice_other_show',
                Configuration::get('WK_CHECKOUT_INVOICE_OTHER_SHOW')
            ),
            'WK_CHECKOUT_INVOICE_OTHER_REQ' => Tools::getValue(
                'wk_checkout_invoice_other_req',
                Configuration::get('WK_CHECKOUT_INVOICE_OTHER_REQ')
            ),

            'WK_CHECKOUT_INVOICE_ALIAS_SHOW' => Tools::getValue(
                'wk_checkout_invoice_alias_show',
                Configuration::get('WK_CHECKOUT_INVOICE_ALIAS_SHOW')
            ),
            'WK_CHECKOUT_INVOICE_ALIAS_REQ' => Tools::getValue(
                'wk_checkout_invoice_alias_req',
                Configuration::get('WK_CHECKOUT_INVOICE_ALIAS_REQ')
            ),

            // Get shipping configuration values
            'WK_CHECKOUT_CARRIER_DESC' => Tools::getValue(
                'wk_checkout_carrier_desc',
                Configuration::get('WK_CHECKOUT_CARRIER_DESC')
            ),
            'WK_CHECKOUT_CARRIER_LOGO' => Tools::getValue(
                'wk_checkout_carrier_logo',
                Configuration::get('WK_CHECKOUT_CARRIER_LOGO')
            ),

            // Get payment configuration values
            'WK_CHECKOUT_PAYMENT_LOGO' => Tools::getValue(
                'wk_checkout_carrier_desc',
                Configuration::get('WK_CHECKOUT_PAYMENT_LOGO')
            ),
            'WK_CHECKOUT_DEFAULT_PAYMENT' => Tools::getValue(
                'wk_checkout_payment_logo',
                Configuration::get('WK_CHECKOUT_DEFAULT_PAYMENT')
            ),

            // Get social login configuration values
            'WK_CHECKOUT_SOCIAL_LOGIN' => Tools::getValue(
                'wk_checkout_social_login',
                Configuration::get('WK_CHECKOUT_SOCIAL_LOGIN')
            ),
            'WK_CHECKOUT_FACEBOOK_LOGIN' => Tools::getValue(
                'wk_checkout_facebook_login',
                Configuration::get('WK_CHECKOUT_FACEBOOK_LOGIN')
            ),
            'WK_CHECKOUT_FB_APP_ID' => Tools::getValue(
                'wk_checkout_fb_app_id',
                Configuration::get('WK_CHECKOUT_FB_APP_ID')
            ),
            'WK_CHECKOUT_FB_SECRET_KEY' => Tools::getValue(
                'wk_checkout_fb_secret_key',
                Configuration::get('WK_CHECKOUT_FB_SECRET_KEY')
            ),

            'WK_CHECKOUT_GOOGLE_LOGIN' => Tools::getValue(
                'wk_checkout_google_login',
                Configuration::get('WK_CHECKOUT_GOOGLE_LOGIN')
            ),
            'WK_CHECKOUT_GOOGLE_APP_KEY' => Tools::getValue(
                'wk_checkout_google_app_key',
                Configuration::get('WK_CHECKOUT_GOOGLE_APP_KEY')
            ),
            'WK_CHECKOUT_GOOGLE_SECRET_KEY' => Tools::getValue(
                'wk_checkout_google_secret_key',
                Configuration::get('WK_CHECKOUT_GOOGLE_SECRET_KEY')
            ),

            // Get cart configuration values
            'WK_CHECKOUT_CART_DETAIL' => Tools::getValue(
                'wk_checkout_cart_detail',
                Configuration::get('WK_CHECKOUT_CART_DETAIL')
            ),
            'WK_CHECKOUT_PRODUCT_IMAGE' => Tools::getValue(
                'wk_checkout_product_image',
                Configuration::get('WK_CHECKOUT_PRODUCT_IMAGE')
            ),
            'WK_CHECKOUT_TERMS_SERVICE' => Tools::getValue(
                'wk_checkout_terms_service',
                Configuration::get('WK_CHECKOUT_TERMS_SERVICE')
            ),
            'WK_CHECKOUT_TERMS_OPTION' => Tools::getValue(
                'wk_checkout_terms_option',
                Configuration::get('WK_CHECKOUT_TERMS_OPTION')
            ),
            'WK_CHECKOUT_CART_SAVE_LATER' => Tools::getValue(
                'wk_checkout_cart_save_later',
                Configuration::get('WK_CHECKOUT_CART_SAVE_LATER')
            ),
            'WK_CHECKOUT_CART_ALSO_BOUGHT' => Tools::getValue(
                'wk_checkout_cart_also_bought',
                Configuration::get('WK_CHECKOUT_CART_ALSO_BOUGHT')
            ),
            'WK_CHECKOUT_ALSO_BOUGHT_NUMBER' => Tools::getValue(
                'wk_checkout_also_bought_number',
                Configuration::get('WK_CHECKOUT_ALSO_BOUGHT_NUMBER')
            )
        );
    }

    public function getCheckoutSession()
    {
        $deliveryOptionsFinder = new DeliveryOptionsFinder(
            $this->context,
            $this->getTranslator(),
            new objectPresenter(),
            new PriceFormatter()
        );

        $session = new CheckoutSession(
            $this->context,
            $deliveryOptionsFinder
        );

        return $session;
    }

    public function hookDisplayOverrideTemplate($params)
    {
        if (Configuration::get('WK_CHECKOUT_MODE')) {
            $valid = false;
            if (Configuration::get('WK_CHECKOUT_SANDBOX')) {
                $currentIp = Tools::getRemoteAddr();
                $whiteIps = Configuration::get('WK_CHECKOUT_IPS');
                if ($whiteIps) {
                    $whiteIps = explode(',', $whiteIps);
                    foreach ($whiteIps as $ip) {
                        if ($currentIp == $ip) {
                            $valid = true;
                            break;
                        }
                    }
                }
            }
            if (Gender::getGenders()) {
                $genders_icon = array();
                $genders = array();
                foreach (Gender::getGenders() as $gender) {
                    $genders_icon[$gender->id] = '../genders/'.(int)$gender->id.'.jpg';
                    $genders[$gender->id] = $gender->name;
                }
                $this->context->smarty->assign('genders', $genders);
            }
            if ($valid || !Configuration::get('WK_CHECKOUT_SANDBOX')) {
                if ($params['template_file'] == 'checkout/checkout') {
                    $this->session = $this->getCheckoutSession();
                    $paymentOptionsFinder = new PaymentOptionsFinder();
                    $conditionsToApproveFinder = new ConditionsToApproveFinder($this->context, $this->getTranslator());
                    $isFree = 0 == (float)$this->session->getCart()->getOrderTotal(true, Cart::BOTH);

                    if ($this->session->getDeliveryOptions()) {
                        $this->context->smarty->assign(array(
                            'is_free' => $isFree,
                            'payment_options' => $this->context->cart->id_address_delivery ?
                            $paymentOptionsFinder->present($isFree) : '',
                        ));
                    }
                    $wk_is_logged = 0;
                    $customer_is_guest = 0;
                    if ($this->context->customer->id) {
                        $customer = new Customer($this->context->customer->id);
                        if ($customer->is_guest) {
                            $customer_is_guest = 1;
                            $this->context->smarty->assign('wkguest', $customer);
                        } else {
                            $this->context->smarty->assign(array(
                                'wkcustomer' => $customer,
                                'myaccount' => $this->context->link->getPageLink('my-account'),
                            ));
                        }
                        if ($customer->getAddresses($this->context->language->id)) {
                            Media::addJsDef(array(
                                'address_exist' => 1
                            ));
                        }
                        $wk_is_logged = 1;
                    }
                    Media::addJsDef(array('wk_is_logged' => $wk_is_logged, 'customer_is_guest' => $customer_is_guest));

                    if (Configuration::get('WK_CHECKOUT_INLINE_VALIDATION')) {
                        Media::addJsDef(array(
                            'inline' => '1'
                        ));
                    }
                    $cartMessage = '';
                    if ($message = Message::getMessageByCartId($this->context->cart->id)) {
                        $cartMessage = $message['message'];
                    }
                    $this->context->smarty->assign(array(
                        'wk_is_logged' => $wk_is_logged,
                        'id_module' => $this->id,
                        'wk_opc_modules_dir' => _MODULE_DIR_.$this->name.'/views/',
                        'countries' => Country::getCountries($this->context->language->id, true),
                        'defaultCountry' => Configuration::get('PS_COUNTRY_DEFAULT'),
                        'delivery_options' => $this->session->getDeliveryOptions(),
                        'delivery_option' => $this->session->getSelectedDeliveryOption(),
                        'conditions_to_approve' => $conditionsToApproveFinder->getConditionsToApproveForTemplate(),
                        'show_final_summary' => Configuration::get('PS_FINAL_SUMMARY_ENABLED'),
                        'quick_view' =>  _PS_THEME_DIR_.'templates/catalog/_partials/quickview.tpl',
                        'logout' => $this->context->link->getPageLink('index', true, null, 'mylogout'),
                        'group' => Group::getPriceDisplayMethod(Group::getCurrent()->id),
                        'id_address' => $this->context->cart->id_address_delivery,
                        'delivery_message' => $cartMessage,
                    ));

                    Media::addJsDef(array(
                        'wk_guest_allow' => Configuration::get('WK_CHECKOUT_GUEST_ALLOW'),
                        'error_length' => $this->l('Field value is too large'),
                        'modules_dir' => _MODULE_DIR_.$this->name.'/views/',
                        'no_payment_select' => $this->l('Please select payment method'),
                        'address_empty' => $this->l('Please fill the delivery address'),
                        'no_shipping_select' => $this->l('Please select shipping method'),
                        'delivery_field_empty' => $this->l('Please fill all information for delivery address'),
                        'delivery_not_created' => $this->l('Delivery address can not be created'),
                        'delivery_adrs_not_select' => $this->l('Delivery address is not selected'),
                        'invoice_field_empty' => $this->l('Please fill all information for invoice address'),
                        'invoice_not_created' => $this->l('Invoice address can not be created'),
                        'invoice_adrs_not_select' => $this->l('Invoice address is not selected'),
                        'email_required' => $this->l('Email is required'),
                        'email_error' => $this->l('Email is not valid'),
                        'email_exist' => $this->l('Email is already taken'),
                        'email_length' => $this->l('Email is length is too large'),
                        'password_length' => $this->l('Password is length is too large'),
                        'password_required' => $this->l('Password is required'),
                        'address_failed' => $this->l('Customer address can not be created'),
                        'user_cancel' => $this->l('User cancelled login or did not fully authorize'),
                        'error_fname' => $this->l('First name is missing'),
                        'error_lname' => $this->l('Last name is missing'),
                        'error_email' => $this->l('Email is missing'),
                        'qty_less' => $this->l('Quantity must be greater than zero'),
                        'wk_no_longer' => $this->l('This product is no longer available'),
                        'wk_no_stock' => $this->l('There are not enough products in stock'),
                        'wk_minimum_qty' => $this->l('You must add minimum quantity'),
                        'wk_max_qty' => $this->l('You already have the maximum quantity available for this product'),
                        'wk_update_qty_err' => $this->l('Something went wrong'),
                        'wk_add_success' => $this->l('Address Created Successfully'),
                        'wk_add_failed' => $this->l('Address can not be created'),
                        'wk_payment_err' => $this->l('Please select one payment method'),
                        'saveSuccessMsg' => $this->l('Successfully added for later'),
                        'deleteSuccessMsg' => $this->l('Cart successfully updated'),
                        'id_cart' => $this->context->cart->id,
                        'id_customer' => $this->context->customer->id,
                        'delivery_date_error' => $this->l('Please select delivery date.'),
                        'delivery_time_error' => $this->l('Please select delivery time slot.'),
                        'fill_payment_error' => $this->l('Please fill payment details.'),
                    ));

                    if (Configuration::get('WK_CHECKOUT_SOCIAL_LOGIN')) {
                        if (Configuration::get('WK_CHECKOUT_FACEBOOK_LOGIN')) {
                            Media::addJsDef(array(
                                'wk_fb_app_id' => Configuration::get('WK_CHECKOUT_FB_APP_ID'),
                                'wk_fb_secret_key' => Configuration::get('WK_CHECKOUT_FB_SECRET_KEY'),
                            ));
                        }

                        if (Configuration::get('WK_CHECKOUT_GOOGLE_LOGIN')) {
                            Media::addJsDef(array(
                                'wk_google_app_key' => Configuration::get('WK_CHECKOUT_GOOGLE_APP_KEY'),
                                'wk_google_secret_key' => Configuration::get('WK_CHECKOUT_FB_SECRET_KEY'),
                            ));
                        }
                    }

                    if (Configuration::get('WK_CHECKOUT_BUTTON_FONT_FAMILY') == 1) {
                        $family = 'Arial, Helvetica, sans-serif';
                    } elseif (Configuration::get('WK_CHECKOUT_BUTTON_FONT_FAMILY') == 2) {
                        $family = 'Comic Sans MS,cursive,sans-serif';
                    } elseif (Configuration::get('WK_CHECKOUT_BUTTON_FONT_FAMILY') == 3) {
                        $family = 'Lucida Sans Unicode, Lucida Grande, sans-serif';
                    } elseif (Configuration::get('WK_CHECKOUT_BUTTON_FONT_FAMILY') == 4) {
                        $family = 'Courier New, Courier, monospace';
                    } elseif (Configuration::get('WK_CHECKOUT_BUTTON_FONT_FAMILY') == 5) {
                        $family = 'Lucida Console, Monaco, monospace';
                    } elseif (Configuration::get('WK_CHECKOUT_BUTTON_FONT_FAMILY') == 6) {
                        $family = 'Montserrat, sans-serif';
                    }

                    $this->context->smarty->assign(array(
                        'fontfamily' => $family,
                    ));
                    return 'module:'.$this->name.'/views/templates/front/wkcheckout.tpl';
                }
            }
        }
    }

    public function hookActionFrontControllerSetMedia($params)
    {
        if ('order' === $this->context->controller->php_self
            && Configuration::get('WK_CHECKOUT_MODE')) {
            $valid = false;
            if (Configuration::get('WK_CHECKOUT_SANDBOX')) {
                $currentIp = Tools::getRemoteAddr();
                $whiteIps = Configuration::get('WK_CHECKOUT_IPS');
                if ($whiteIps) {
                    $whiteIps = explode(',', $whiteIps);
                    foreach ($whiteIps as $ip) {
                        if ($currentIp == $ip) {
                            $valid = true;
                            break;
                        }
                    }
                }
            }

            if (($valid || !Configuration::get('WK_CHECKOUT_SANDBOX'))) {

                $this->context->controller->addJqueryPlugin('growl', null, true);
                $this->context->controller->registerStylesheet(
                    'growl-css',
                    'js/jquery/plugins/growl/jquery.growl.css',
                    array('media' => 'all', 'priority' => 1000)
                );

                Media::addJsDef(array(
                    'wkvirtualcart' => $this->context->cart->isVirtualCart(),
                    'wkcheckout' => $this->context->link->getModuleLink($this->name, 'wkcheckout'),
                    'wkorder' => $this->context->link->getPageLink('order'),
                    'wkhome' => $this->context->link->getPageLink('index'),
                    'wkcart' => $this->context->link->getPageLink('cart'),
                    'wktoken' => Tools::getToken(false),
                    'fbConnectionError' => $this->l('Something went wrong')
                ));

                $this->context->controller->registerStylesheet(
                    'module-wkonepagecheckout-wkcheckout',
                    'modules/'.$this->name.'/views/css/wkcheckout.css'
                );

                $this->context->controller->registerJavascript(
                    'module-wkonepagecheckout-wkcheckout',
                    'modules/'.$this->name.'/views/js/wkcheckout.js',
                    array('position' => 'top', 'priority' => 999)
                );


                if (Configuration::get('WK_CHECKOUT_SOCIAL_LOGIN')) {
                    $this->context->controller->registerJavascript(
                        'module-wkonepagecheckout-wkcheckout_social_login',
                        'modules/'.$this->name.'/views/js/wkcheckout_social_login.js'
                    );
                }
            }
        }
    }

    public function hookDisplayWhoBoughtAlsoBought()
    {
        $products = $this->processWhoBoughtAlsoBought();
        if (!empty($products)) {
            $this->context->smarty->assign(array(
                'products' => $products,
            ));
            return $this->fetch('module:'.$this->name.'/views/templates/hook/wk-also-bought.tpl');
        }
    }

    public function processWhoBoughtAlsoBought()
    {
        $productIds = array_map(function ($elem) {
            return $elem['id_product'];
        }, $this->context->cart->getProducts());

        $productIds = array_unique($productIds);
        if (!empty($productIds)) {
            return WkOnePageCheckoutHelper::getOrderProducts($productIds);
        }
    }

    public function updateDefaultConfigurationValue()
    {
        // Update general configuration values
        Configuration::updateValue('WK_CHECKOUT_MODE', 1);
        Configuration::updateValue('WK_CHECKOUT_SANDBOX', 0);

        // updateValue customizer configuration values
        Configuration::updateValue('WK_CHECKOUT_BUTTON_COLOR', '#2fb5d2');
        Configuration::updateValue('WK_CHECKOUT_BUTTON_FONT_SIZE', 15);
        Configuration::updateValue('WK_CHECKOUT_BUTTON_FONT_COLOR', '#ffffff');
        Configuration::updateValue('WK_CHECKOUT_BUTTON_FONT_FAMILY', '1');

        // updateValue login and registration configuration values
        Configuration::updateValue(
            'WK_CHECKOUT_GUEST_ALLOW',
            Configuration::get('PS_GUEST_CHECKOUT_ENABLED')
        );
        Configuration::updateValue('WK_CHECKOUT_DEFAULT_GROUP', '3');
        Configuration::updateValue('WK_CHECKOUT_SHOW_ADDRESS_BUTTON', '1');
        Configuration::updateValue('WK_CHECKOUT_INLINE_VALIDATION', '1');
        Configuration::updateValue('WK_CHECKOUT_SOCIAL_TITLE', '0');
        Configuration::updateValue('WK_CHECKOUT_DOB', '0');
        Configuration::updateValue('WK_CHECKOUT_OPTIN', '0');
        Configuration::updateValue('WK_CHECKOUT_NEWSLATTER', '0');

        // updateValue delivery address configuration values
        Configuration::updateValue('WK_CHECKOUT_DELIVERY_AS_INVOICE', '1');

        Configuration::updateValue('WK_CHECKOUT_DELIVERY_COMPANY_SHOW', '0');
        Configuration::updateValue('WK_CHECKOUT_DELIVERY_COMPANY_REQ', '0');

        Configuration::updateValue('WK_CHECKOUT_DELIVERY_DNI_SHOW', '0');
        Configuration::updateValue('WK_CHECKOUT_DELIVERY_DNI_REQ', '0');

        Configuration::updateValue('WK_CHECKOUT_DELIVERY_ADDRESS_COMPLEM_SHOW', '0');
        Configuration::updateValue('WK_CHECKOUT_DELIVERY_ADDRESS_COMPLEM_REQ', '0');

        Configuration::updateValue('WK_CHECKOUT_DELIVERY_PHONE_SHOW', '0');
        Configuration::updateValue('WK_CHECKOUT_DELIVERY_PHONE_REQ', '0');

        Configuration::updateValue('WK_CHECKOUT_DELIVERY_MOBILE_PHONE_SHOW', '0');
        Configuration::updateValue('WK_CHECKOUT_DELIVERY_MOBILE_PHONE_REQ', '0');

        Configuration::updateValue('WK_CHECKOUT_DELIVERY_OTHER_SHOW', '0');
        Configuration::updateValue('WK_CHECKOUT_DELIVERY_OTHER_REQ', '0');

        Configuration::updateValue('WK_CHECKOUT_DELIVERY_ALIAS_SHOW', '0');
        Configuration::updateValue('WK_CHECKOUT_DELIVERY_ALIAS_REQ', '0');

        // updateValue invoice address configuration values
        Configuration::updateValue('WK_CHECKOUT_INVOICE_COMPANY_SHOW', '0');
        Configuration::updateValue('WK_CHECKOUT_INVOICE_COMPANY_REQ', '0');

        Configuration::updateValue('WK_CHECKOUT_INVOICE_DNI_SHOW', '0');
        Configuration::updateValue('WK_CHECKOUT_INVOICE_DNI_REQ', '0');

        Configuration::updateValue('WK_CHECKOUT_INVOICE_ADDRESS_COMPLEM_SHOW', '0');
        Configuration::updateValue('WK_CHECKOUT_INVOICE_ADDRESS_COMPLEM_REQ', '0');

        Configuration::updateValue('WK_CHECKOUT_INVOICE_PHONE_SHOW', '0');
        Configuration::updateValue('WK_CHECKOUT_INVOICE_PHONE_REQ', '0');

        Configuration::updateValue('WK_CHECKOUT_INVOICE_MOBILE_PHONE_SHOW', '0');
        Configuration::updateValue('WK_CHECKOUT_INVOICE_MOBILE_PHONE_REQ', '0');

        Configuration::updateValue('WK_CHECKOUT_INVOICE_OTHER_SHOW', '0');
        Configuration::updateValue('WK_CHECKOUT_INVOICE_OTHER_REQ', '0');

        Configuration::updateValue('WK_CHECKOUT_INVOICE_ALIAS_SHOW', '0');
        Configuration::updateValue('WK_CHECKOUT_INVOICE_ALIAS_REQ', '0');

        // updateValue shipping configuration values
        Configuration::updateValue('WK_CHECKOUT_CARRIER_DESC', '1');
        Configuration::updateValue('WK_CHECKOUT_CARRIER_LOGO', '1');

        // updateValue payment configuration values
        Configuration::updateValue('WK_CHECKOUT_PAYMENT_LOGO', '1');

        // updateValue social login configuration values
        Configuration::updateValue('WK_CHECKOUT_SOCIAL_LOGIN', '0');
        Configuration::updateValue('WK_CHECKOUT_FACEBOOK_LOGIN', '0');
        Configuration::updateValue('WK_CHECKOUT_GOOGLE_LOGIN', '0');

        // updateValue cart configuration values
        Configuration::updateValue('WK_CHECKOUT_CART_DETAIL', '0');
        Configuration::updateValue('WK_CHECKOUT_PRODUCT_IMAGE', '2');
        Configuration::updateValue('WK_CHECKOUT_CART_SAVE_LATER', '1');
        Configuration::updateValue('WK_CHECKOUT_CART_ALSO_BOUGHT', '1');
        Configuration::updateValue('WK_CHECKOUT_ALSO_BOUGHT_NUMBER', '4');
        Configuration::updateValue('WK_CHECKOUT_TERMS_SERVICE', Configuration::get('PS_CONDITIONS'));
        Configuration::updateValue('WK_CHECKOUT_TERMS_OPTION', Configuration::get('PS_CONDITIONS_CMS_ID'));


        return true;
    }

    public function hookActionProductDelete($params)
    {
        if ($idProduct = $params['id_product']) {
            $objSavedCart = new WkOnePageCheckOutSaveCart();
            $objSavedCart->deleteSavedCartByIdProduct($idProduct);
        }
    }

    public function install()
    {
        $wkOnePageCheckoutDb = new WkOnePageCheckoutDb();
        if (!parent::install()
            || !$this->updateDefaultConfigurationValue()
            || !$this->registerHook('displaycustomerAccount')
            || !$this->registerHook('displayWhoBoughtAlsoBought')
            || !$this->registerHook('actionFrontControllerSetMedia')
            || !$this->registerHook('actionProductDelete')
            || !$this->registerHook('displayHeader')
            || !$this->registerHook('moduleRoutes')
            || !$this->registerHook('displayOverrideTemplate')
            || !$this->registerHook('actionDeleteGDPRCustomer')
            || !$this->registerHook('registerGDPRConsent')
            || !$this->callInstallTab()
            || !$wkOnePageCheckoutDb->createTables()
            ) {
            return false;
        }

        return true;
    }


    // If customer is getting delete then we delete the customer saved cart
    public function hookActionDeleteGDPRCustomer($customer)
    {
        if (!Tools::isEmpty($customer['email']) && Validate::isEmail($customer['email'])) {
            $objSavedCart = new WkOnePageCheckOutSaveCart();
            if (!$objSavedCart->deleteSavedCartByIdCustomer($customer['id'])) {
                return json_encode($this->l('Unable to delete one page checked customer saved cart product(s).'));
            }
        }
    }

    public function callInstallTab()
    {
        $this->installTab('AdminOpcConfiguration', 'One Page Checkout', 'ShopParameters');
        return true;
    }

    public function installTab($class_name, $tab_name, $tab_parent_name = false)
    {
        $tab = new Tab();
        $tab->active = 1;
        $tab->class_name = $class_name;
        $tab->name = array();

        foreach (Language::getLanguages(true) as $lang) {
            $tab->name[$lang['id_lang']] = $tab_name;
        }

        if ($tab_parent_name) {
            $tab->id_parent = (int)Tab::getIdFromClassName($tab_parent_name);
        } else {
            $tab->id_parent = 0;
        }

        $tab->module = $this->name;
        return $tab->add();
    }

    public function deleteConfigurationValue()
    {
        $config = array(

            // General configuration
            'WK_CHECKOUT_MODE', 'WK_CHECKOUT_SANDBOX', 'WK_CHECKOUT_IPS',

            //  Customizer configuration
            'WK_CHECKOUT_BUTTON_COLOR', 'WK_CHECKOUT_BUTTON_FONT_SIZE',
            'WK_CHECKOUT_BUTTON_FONT_COLOR', 'WK_CHECKOUT_BUTTON_FONT_FAMILY',

            // login and registration configuration
            'WK_CHECKOUT_GUEST_ALLOW', 'WK_CHECKOUT_DEFAULT_GROUP', 'WK_CHECKOUT_SHOW_ADDRESS_BUTTON',
            'WK_CHECKOUT_INLINE_VALIDATION', 'WK_CHECKOUT_SOCIAL_TITLE', 'WK_CHECKOUT_DOB',
            'WK_CHECKOUT_OPTIN', 'WK_CHECKOUT_NEWSLATTER',

            // Delivery address configuration
            'WK_CHECKOUT_DELIVERY_AS_INVOICE',
            'WK_CHECKOUT_DELIVERY_COMPANY_SHOW', 'WK_CHECKOUT_DELIVERY_COMPANY_REQ',
            'WK_CHECKOUT_DELIVERY_DNI_SHOW', 'WK_CHECKOUT_DELIVERY_DNI_REQ',
            'WK_CHECKOUT_DELIVERY_ADDRESS_COMPLEM_SHOW', 'WK_CHECKOUT_DELIVERY_ADDRESS_COMPLEM_REQ',
            'WK_CHECKOUT_DELIVERY_PHONE_SHOW', 'WK_CHECKOUT_DELIVERY_PHONE_REQ',
            'WK_CHECKOUT_DELIVERY_MOBILE_PHONE_SHOW', 'WK_CHECKOUT_DELIVERY_MOBILE_PHONE_REQ',
            'WK_CHECKOUT_DELIVERY_OTHER_SHOW', 'WK_CHECKOUT_DELIVERY_OTHER_REQ',
            'WK_CHECKOUT_DELIVERY_ALIAS_SHOW', 'WK_CHECKOUT_DELIVERY_ALIAS_REQ',

            // Invoice address configuration
            'WK_CHECKOUT_INVOICE_AS_INVOICE',
            'WK_CHECKOUT_INVOICE_COMPANY_SHOW', 'WK_CHECKOUT_INVOICE_COMPANY_REQ',
            'WK_CHECKOUT_INVOICE_DNI_SHOW', 'WK_CHECKOUT_INVOICE_DNI_REQ',
            'WK_CHECKOUT_INVOICE_ADDRESS_COMPLEM_SHOW', 'WK_CHECKOUT_INVOICE_ADDRESS_COMPLEM_REQ',
            'WK_CHECKOUT_INVOICE_PHONE_SHOW', 'WK_CHECKOUT_INVOICE_PHONE_REQ',
            'WK_CHECKOUT_INVOICE_MOBILE_PHONE_SHOW', 'WK_CHECKOUT_INVOICE_MOBILE_PHONE_REQ',
            'WK_CHECKOUT_INVOICE_OTHER_SHOW', 'WK_CHECKOUT_INVOICE_OTHER_REQ',
            'WK_CHECKOUT_INVOICE_ALIAS_SHOW', 'WK_CHECKOUT_INVOICE_ALIAS_REQ',

            // Shipping configuration
            'WK_CHECKOUT_CARRIER_DESC', 'WK_CHECKOUT_CARRIER_LOGO',

            // Payment configuration
            'WK_CHECKOUT_PAYMENT_LOGO', 'WK_CHECKOUT_DEFAULT_PAYMENT',

            // Social login configuration
            'WK_CHECKOUT_SOCIAL_LOGIN',
            'WK_CHECKOUT_FACEBOOK_LOGIN', 'WK_CHECKOUT_FB_APP_ID', 'WK_CHECKOUT_FB_SECRET_KEY',
            'WK_CHECKOUT_GOOGLE_LOGIN', 'WK_CHECKOUT_GOOGLE_APP_KEY', 'WK_CHECKOUT_GOOGLE_SECRET_KEY',

            // Cart configuration
            'WK_CHECKOUT_CART_DETAIL', 'WK_CHECKOUT_PRODUCT_IMAGE',
            'WK_CHECKOUT_TERMS_SERVICE', 'WK_CHECKOUT_TERMS_OPTION',
            'WK_CHECKOUT_CART_SAVE_LATER', 'WK_CHECKOUT_CART_ALSO_BOUGHT', 'WK_CHECKOUT_ALSO_BOUGHT_NUMBER'

        );

        foreach ($config as $key) {
            Configuration::deleteByName($key);
        }

        return true;
    }

    public function uninstallTab()
    {
        $moduleTabs = Tab::getCollectionFromModule($this->name);
        if (!empty($moduleTabs)) {
            foreach ($moduleTabs as $moduleTab) {
                $moduleTab->delete();
            }
            return true;
        }
        return false;
    }

    public function uninstall()
    {
        $wkOnePageCheckoutDb = new WkOnePageCheckoutDb();
        if (!parent::uninstall()
            || !$this->uninstallTab()
            || !$this->deleteConfigurationValue()
            || !$wkOnePageCheckoutDb->deleteTables()
            ) {
            return false;
        }

        return true;
    }
}
