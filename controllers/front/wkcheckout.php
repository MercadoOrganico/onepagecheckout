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

use PrestaShop\PrestaShop\Adapter\Product\PriceFormatter;
use PrestaShop\PrestaShop\Adapter\Cart\CartPresenter;
use PrestaShop\PrestaShop\Core\Product\ProductExtraContentFinder;
use Symfony\Component\Translation\TranslatorInterface;
use PrestaShop\PrestaShop\Adapter\ObjectPresenter;

use PrestaShop\PrestaShop\Core\Crypto\Hashing as Crypto;

class WkOnePageCheckOutWkCheckOutModuleFrontController extends ModuleFrontController
{
    /* Adriana - 04/10/2020 - início */
    /** @var CheckoutSession */
    private $session;
    /* Adriana - 04/10/2020 - fim */

    public function __construct()
    {
        parent::__construct();
        $this->session = $this->getCheckoutSession();
    }

    public function getCheckoutSession()
    {
        $deliveryOptionsFinder = new DeliveryOptionsFinder(
            $this->context,
            $this->getTranslator(),
            $this->objectPresenter,
            new PriceFormatter()
        );

        $session = new CheckoutSession(
            $this->context,
            $deliveryOptionsFinder
        );

        return $session;
    }

    public function initContent()
    {
        parent::initContent();
        if (!$this->isTokenValid()) {
            if (Tools::getValue('action') == 'validateLogin'
                && $this->context->customer->isLogged()
            ) {
                $data = array('status' => 'ok');
                die(json_encode($data));
            }
            die($this->module->l('Invalid token', 'wkcheckout'));
        }
        $this->context->smarty->assign(array(
            'p_img' => _PS_PROD_IMG_DIR_,
            'wk_opc_modules_dir' => _MODULE_DIR_.$this->module->name.'/views/',
            'group' => Group::getPriceDisplayMethod(Group::getCurrent()->id),
            'id_module' => $this->module->id,
        ));
    }

    public function displayAjaxProceedLogin()
    {
        $email = trim(Tools::getValue('email'));
        $first_name = trim(Tools::getValue('first_name'));
        $last_name = trim(Tools::getValue('last_name'));
        if ($email && $first_name && $last_name) {
            $customer = new Customer();
            $authentication = $customer->getByEmail($email);
            if (!$authentication) {
                $customer->firstname = $first_name;
                $customer->lastname = $last_name;
                $customer->active = 1;
                $customer->email = $email;
                $customer->passwd = md5(_COOKIE_KEY_.rand());
                $customer->save();
            } else {
                $customer = new Customer($authentication->id);
            }

            $this->context->updateCustomer($customer);
            // check cart rule
            CartRule::autoRemoveFromCart($this->context);
            CartRule::autoAddToCart($this->context);
            die('1');
        } else {
            die('0');
        }
    }

    public function displayAjaxValidateLogin()
    {
        $data = array('status' => 'ok');
        $params = array();
        parse_str(Tools::getValue('params'), $params);
        $email = trim($params['wk-login-email']);
        $password = trim($params['wk-login-password']);

        if (!$email) {
            $data['msg'] = $this->module->l('Email can not be empty', 'wkcheckout');
            $data['status'] = 'ko';
            $data['id'] = 'wk-login-email';
        } elseif (!Validate::isEmail($email)) {
            $data['msg'] = $this->module->l('Email is not valid', 'wkcheckout');
            $data['status'] = 'ko';
            $data['id'] = 'wk-login-email';
        } elseif (!$password) {
            $data['msg'] = $this->module->l('Password can not be empty', 'wkcheckout');
            $data['status'] = 'ko';
            $data['id'] = 'wk-login-password';
        } elseif (!Validate::isPasswd($password)) {
            $data['msg'] = $this->module->l('Password is not valid', 'wkcheckout');
            $data['status'] = 'ko';
            $data['id'] = 'wk-login-password';
        } else {
            return $this->updateLogin($email, $password);
        }

        die(json_encode($data));
    }

    public function updateLogin($email, $password)
    {
        $data = array();
        $customer = new Customer();
        $authentication = $customer->getByEmail($email, $password);
        if (isset($authentication->active) && !$authentication->active) {
            $data['msg'] = $this->module->l('Your account isn\'t available, please contact us', 'wkcheckout');
            $data['status'] = 'ko';
        } elseif (!$authentication || !$customer->id || $customer->is_guest) {
            $data['msg'] = $this->module->l('Authentication failed.', 'wkcheckout');
            $data['status'] = 'ko';
        } else {
            $this->context->updateCustomer($customer);

            //Hook::exec('actionAuthentication', ['customer' => $this->context->customer]);

            // Login information have changed, so we check if the cart rules still apply
            CartRule::autoRemoveFromCart($this->context);
            CartRule::autoAddToCart($this->context);
            $data['status'] = 'ok';
        }
        die(json_encode($data));
    }

    public function displayAjaxCheckEmail()
    {
        $data = array('status' => 'ok');
        $email = Tools::getValue('email');
        if (!$email) {
            $data = array(
                'status' => 'ko',
                'id' => 'wk-email',
                'msg' => $this->module->l('Email is required', 'wkcheckout')
            );
        } elseif (!Validate::isEmail($email)) {
            $data = array(
                'status' => 'ko',
                'id' => 'wk-email',
                'msg' => $this->module->l('Email is not valid', 'wkcheckout')
            );
        } elseif (Customer::customerExists($email, false, true)) {
            $data = array(
                'status' => 'ko',
                'id' => 'wk-email',
                'msg' => $this->module->l('Email is already taken', 'wkcheckout')
                );
        }
        die(json_encode($data));
    }

    public function displayAjaxCreateAccount()
    {
        if (isset($this->context->cart->id_guest)) {
            $guest = new Guest($this->context->cart->id_guest);
            $email = Tools::getValue('email');
            $create_account = Tools::getValue('create_account');
            if (!Configuration::get('WK_CHECKOUT_GUEST_ALLOW')) {
                $create_account = 1;
            }
            if (!$this->context->customer->id) {
                $fname = Tools::getValue('fname');
                $lname = Tools::getValue('lname');
                $password = Tools::getValue('password');
                $objCrypto = new Crypto();
                if (!$create_account) {
                    $password = $objCrypto->hash(
                        microtime(),
                        _COOKIE_KEY_
                    );
                } else {
                    $password = $objCrypto->hash(
                        $password,
                        _COOKIE_KEY_
                    );
                }

                $customer = new Customer();
                $customer->firstname = $fname;
                $customer->lastname = $lname;
                $customer->email = $email;
                $customer->passwd = $password;
                if (!$create_account) {
                    $customer->is_guest = 1;
                }

                $id_gender = Tools::getValue('social_title');
                $wk_optin = Tools::getValue('wk_optin');
                $wk_newsletter = Tools::getValue('wk_newsletter');
                $wk_day = Tools::getValue('wk_day');
                $wk_month = Tools::getValue('wk_month');
                $wk_year = Tools::getValue('wk_year');

                if ($wk_year > 0 && $wk_month > 0 && $wk_day > 0) {
                    $dob = $wk_year.'-'.$wk_month.'-'.$wk_day;
                    $customer->birthday = $dob;
                }

                if ($id_gender) {
                    $customer->id_gender = $id_gender;
                }

                if ($wk_optin) {
                    $customer->optin = $wk_optin;
                }

                if ($wk_newsletter) {
                    $customer->newsletter = $wk_newsletter;
                }

                $customer->id_default_group = Configuration::get('WK_CHECKOUT_DEFAULT_GROUP');
                $customer->save();

                $guest = new Guest($this->context->cart->id_guest);
                $guest->id_customer = $customer->id;
                $guest->update();

                $this->context->updateCustomer($customer);
                $this->context->cart->update();
                die(Tools::getToken(false));
            } else {
                if ($this->context->customer->id) {
                    $customer = new Customer($this->context->customer->id);
                    $customer->email = $email;
                    $customer->update();
                }
                die(Tools::getToken(false));
            }
        } else {
            die(false);
        }
    }

    public function displayAjaxShowTermCondition()
    {
        $idCms = Tools::getValue('idCms');
        $cms = new CMS($idCms, $this->context->language->id);
        if ($cms) {
            $this->context->smarty->assign(array('cmsContent' => $cms->content));
        }
        die($this->context->smarty->fetch(
            'module:wkonepagecheckout/views/templates/front/content/_partials/wk-cms-condition.tpl'
        ));
    }

    public function displayAjaxSetDeliveryOption()
    {
        // $option - be like id_address_delivery will be key and id_carrier will be value
        // $option = array('5' => '13');

        $option = array();
        $idCarrier = Tools::getValue('idCarrier');
        $option = array($this->context->cart->id_address_delivery => $idCarrier.',');

        $this->session->setDeliveryOption($option); // update carrier with customer address
        die('true');
    }

    public function displayAjaxChangeAddressCard()
    {
        $address = Tools::getValue('address');
        $idAddress = (int) Tools::getValue('idAddress');
        $idAddressInvoice = (int) Tools::getValue('idAddressInvoice');
        $this->updateAddressIntoCart($idAddress, $idAddressInvoice);

        if ($address == 'delivery') {
            die(AddressFormat::generateAddress(new Address($idAddress), array(), '<br>'));
        } elseif ($address == 'invoice') {
            die(AddressFormat::generateAddress(new Address($idAddressInvoice), array(), '<br>'));
        } else {
            die(false);
        }
    }

    public function updateAddressIntoCart($idAddress = false, $idAddressInvoice = false)
    {
        $this->session->setIdAddressDelivery($idAddress);
        if (!$idAddressInvoice) {
            $idAddressInvoice = $idAddress;
        }
        $this->session->setIdAddressInvoice($idAddressInvoice);

        // Clear the cache to fetch new delivery carrier list.
        $this->context->cart->getDeliveryOptionList(null, true);
        $bestShipping = explode(',', $this->session->getSelectedDeliveryOption());
        $option = array($idAddress => $bestShipping[0].',');
        $this->session->setDeliveryOption($option); // update carrier with customer address
        return true;
    }

    public function displayAjaxUpdateQty()
    {
        $qty = Tools::getValue('qty');
        $operator = Tools::getValue('operator');
        $idProduct = Tools::getValue('idProduct');
        $idProductAttribute = Tools::getValue('idProductAttribute');
        $idCustomization = Tools::getValue('idCustomization');

        if ($qty > 0) {
            $product = new Product($idProduct, true, $this->context->language->id);
            if (!$product->id || !$product->active || !$product->checkAccess($this->context->cart->id_customer)) {
                die('0'); //This product is no longer available
            }

            // Check product quantity availability
            if ($idProductAttribute) {
                if (!Product::isAvailableWhenOutOfStock($product->out_of_stock)
                && !Attribute::checkAttributeQty($idProductAttribute, $qty)) {
                    die('2');   //There are not enough products in stock
                }
            } elseif ($product->hasAttributes()) {
                $minimumQuantity = ($product->out_of_stock == 2) ?
                !Configuration::get('PS_ORDER_OUT_OF_STOCK') : !$product->out_of_stock;
                $idProductAttribute = Product::getDefaultAttribute($product->id, $minimumQuantity);
                // @todo do something better than a redirect admin !!
                if (!$idProductAttribute) {
                    Tools::redirectAdmin($this->context->link->getProductLink($product));
                } elseif (!Product::isAvailableWhenOutOfStock($product->out_of_stock)
                && !Attribute::checkAttributeQty($idProductAttribute, $qty)) {
                    die('2');   //There are not enough products in stock
                }
            } elseif (!$product->checkQty($qty)) {
                die('2');   //There are not enough products in stock
            }

            $update_quantity = $this->context->cart->updateQty(
                $qty,
                $idProduct,
                $idProductAttribute,
                $idCustomization,
                $operator,
                $this->context->cart->id_address_delivery
            );
            if ($update_quantity < 0) {
                // If product has attribute, minimal quantity is set with minimal quantity of attribute
                /*$minimal_quantity = ($idProductAttribute) ?
                Attribute::getAttributeMinimalQty($idProductAttribute) : $product->minimal_quantity;*/
                die('3');   //You must add %d minimum quantity
            } elseif (!$update_quantity) {
                die('4');   //You already have the maximum quantity available for this product
            }

            CartRule::autoRemoveFromCart();
            CartRule::autoAddToCart();

            return $this->displayAjaxUpdateOrderSummary();
        } else {
            die('7'); // No change in quantity
        }
    }

    public function displayAjaxAddDeliveryMessage()
    {
        $id_cart = trim(Tools::getValue('id_cart'));
        $id_customer = trim(Tools::getValue('id_customer'));
        $message = trim(Tools::getValue('message'));
        $messageData = Message::getMessageByCartId($id_cart);
        if ($id_cart && $id_customer) {
            if ($messageData) {
                $messageObj = new Message($messageData['id_message']);
            } else {
                $messageObj = new Message();
            }
            $messageObj->id_cart = $id_cart;
            $messageObj->id_customer = $id_customer;
            $messageObj->message = $message;
            $messageObj->save();
            die('1');
        } else {
            die('0');
        }
    }

    public function displayAjaxSaveCartProduct()
    {
        $idProduct = Tools::getValue('idProduct');
        $idProductAttribute = Tools::getValue('idProductAttribute');
        $quantity = Tools::getValue('qty');
        if ($idProduct && $this->context->customer->id) {
            $objSaveCart = new WkOnePageCheckOutSaveCart();

            $isExist = WkOnePageCheckOutSaveCart::isExist($idProduct, $idProductAttribute, $this->context->cart->id);
            if ($isExist) {
                $objSaveCart = new WkOnePageCheckOutSaveCart($isExist);
            }

            $objSaveCart->id_product = $idProduct;
            $objSaveCart->id_product_attribute = $idProductAttribute;
            $objSaveCart->id_cart = (int) $this->context->cart->id;
            $objSaveCart->quantity += (int) $quantity;
            $objSaveCart->id_customer = $this->context->customer->id;
            if ($objSaveCart->save()) {
                die('1');
            } else {
                die('0');
            }
        } else {
            die('0');
        }
    }

    public function displayAjaxDeleteCartProduct()
    {
        $idProduct = Tools::getValue('idProduct');
        $idProductAttribute = Tools::getValue('idProductAttribute');
        $idCustomization = Tools::getValue('idCustomization');
        // Customization by ram chandra : basket subscription module (Restrict product deletion if the basket is added to cart)
        if (Module::isEnabled('wkcartsubscription') && ($idModule = Module::getModuleIdByName('wkcartsubscription'))) {
            Hook::exec('actionObjectProductInCartDeleteBefore', array(), $idModule);
        }

        if ($this->context->cart->deleteProduct(
            $idProduct,
            $idProductAttribute,
            $idCustomization,
            $this->context->cart->id_address_delivery
        )) {
            // Hook::exec('actionObjectProductInCartDeleteAfter', $data);

            if (!Cart::getNbProducts((int)$this->context->cart->id)) {
                $this->context->cart->setDeliveryOption(null);
                $this->context->cart->gift = 0;
                $this->context->cart->gift_message = '';
                $this->context->cart->update();
            }
        }

        CartRule::autoRemoveFromCart();
        CartRule::autoAddToCart();
        if (!$this->context->cart->getProducts()) {
            die(false);
        }
        return $this->displayAjaxUpdateOrderSummary();
    }

    public function displayAjaxUpdateOrderSummary()
    {
        $this->context->smarty->assign(array(
            'cartProduct' => (new CartPresenter)->present($this->context->cart),
        ));
        if (!count($this->context->cart->getProducts())) {
            die('6'); // cart is empty now. So reload the page
        }
        die($this->context->smarty->fetch('module:wkonepagecheckout/views/templates/front/content/wkordersummary.tpl'));
    }

    public function displayAjaxCheckProductQuantity()
    {
        $cartProduct = $this->context->cart->getProducts();
        $data = array();
        if ($cartProduct) {
            foreach ($cartProduct as $productInfo) {
                $product = new Product($productInfo['id_product'], null, $this->context->language->id);
                $qtyToCheck = $productInfo['cart_quantity'];
                if ($productInfo['id_product_attribute']) {
                    $result = (!Product::isAvailableWhenOutOfStock($product->out_of_stock)
                        && !Attribute::checkAttributeQty($productInfo['id_product_attribute'], $qtyToCheck));
                } else {
                    $result =  (!$product->checkQty($qtyToCheck));
                }
                if ($result) {
                    $data[$productInfo['id_product']]['status'] = 'ko';
                    $data[$productInfo['id_product']]['msg'] = sprintf(
                        $this->module->l('The %s in your cart is no longer available in this quantity.', 'wkcheckout'),
                        $product->name
                    );
                }
            }
        }
        die(json_encode($data));
    }

    public function displayAjaxUpdateShipping()
    {
        $isLogged = Tools::getValue('wk_is_logged');
        $newAddress = Tools::getValue('newAddress');
        if ($isLogged) {
            // Clear the cache to fetch new delivery carrier list.
            $this->context->cart->getDeliveryOptionList(null, true);
            if (!$newAddress) {
                $this->context->smarty->assign(
                    array(
                        'delivery_option' => $this->session->getSelectedDeliveryOption(),
                        'delivery_options' => $this->session->getDeliveryOptions()
                    )
                );
            } else {
                $idCountry = Tools::getValue('idCountry');
                $idState = Tools::getValue('idState');
                if ($idState) {
                    // getting available carrier based on state
                    $delivery_option_list = $this->getDeliveryOptionListByIdCountry($idCountry, $idState);
                } else {
                    // getting available carrier based on country
                    $delivery_option_list = $this->getDeliveryOptionListByIdCountry($idCountry);
                }
                $carriers = $this->getDeliveryOptionsByIdCountry($delivery_option_list);
                $this->context->smarty->assign(
                    array(
                        'delivery_option' => $this->session->getSelectedDeliveryOption(),
                        'delivery_options' => $carriers
                    )
                );
            }
        }
        $cartMessage = '';
        if ($message = Message::getMessageByCartId($this->context->cart->id)) {
            $cartMessage = $message['message'];
        }
        $this->context->smarty->assign(array(
            'wk_is_logged' => $isLogged,
            'id_address' => $this->context->cart->id_address_delivery,
            'delivery_message' => $cartMessage,
        ));
        die($this->context->smarty->fetch(
            'module:wkonepagecheckout/views/templates/front/content/wkshippingmethod.tpl'
        ));
    }

    public function displayAjaxUpdatePaymentMethod()
    {
        $isLogged = Tools::getValue('wk_is_logged');
        $showPayment = Tools::getValue('showPayment');
        $isFree = 0 == (float)$this->session->getCart()->getOrderTotal(true, Cart::BOTH);
        $this->context->smarty->assign(array('is_free' => $isFree));
        $paymentOptionsFinder = new PaymentOptionsFinder();
        $conditionsToApproveFinder = new ConditionsToApproveFinder($this->context, $this->getTranslator());

        if ($isLogged) {
            if ($showPayment) {
                $this->context->smarty->assign(array(
                    'payment_options' => $paymentOptionsFinder->present($isFree),
                    'conditions_to_approve' => $conditionsToApproveFinder->getConditionsToApproveForTemplate(),
                    'show_final_summary' => Configuration::get('PS_FINAL_SUMMARY_ENABLED'),
                ));
            } else {
                $idCountry = (int) Tools::getValue('idCountry');
                $idCarrier = (int) Tools::getValue('idCarrier');
                if ($idCountry) {
                    $delivery_option_list = $this->getDeliveryOptionListByIdCountry($idCountry);
                    $carriers = $this->getDeliveryOptionsByIdCountry($delivery_option_list);
                    $payment_options = $this->checkPaymentMethodByIdCountry(
                        $paymentOptionsFinder->present(),
                        $idCountry
                    );

                    if ($idCarrier) {
                        $payment_options = $this->checkPaymentMethodByIdCarrier($payment_options, $idCarrier);
                    }

                    if (!empty($carriers)) {
                        $this->context->smarty->assign(array(
                            'payment_options' => $payment_options,
                            'conditions_to_approve' => $conditionsToApproveFinder->getConditionsToApproveForTemplate(),
                            'show_final_summary' => Configuration::get('PS_FINAL_SUMMARY_ENABLED'),
                        ));
                    } else {
                        $this->context->smarty->assign(array(
                            'payment_options' => '',
                        ));
                    }
                }
            }
        }
        $this->context->smarty->assign('wk_is_logged', $isLogged);
        die($this->context->smarty->fetch(
            'module:wkonepagecheckout/views/templates/front/content/wkpaymentmethod.tpl'
        ));
    }

    public function checkPaymentMethodByIdCountry($paymentMethod, $idCountry)
    {
        if ($paymentMethod) {
            foreach ($paymentMethod as $key => $payment) {
                if ($payment) {
                    $idModule = WkOnePageCheckoutHelper::getModuleIdByName($key);
                    if (!WkOnePageCheckoutHelper::checkCountryRestrictionByIdModule($idModule, $idCountry)) {
                        unset($paymentMethod[$key]);
                    }
                }
            }
        }
        return $paymentMethod;
    }

    public function checkPaymentMethodByIdCarrier($paymentMethod, $idCarrier)
    {
        $carrier = new Carrier($idCarrier);
        if ($paymentMethod) {
            foreach ($paymentMethod as $key => $payment) {
                if ($payment) {
                    $idModule = WkOnePageCheckoutHelper::getModuleIdByName($key);
                    if (!WkOnePageCheckoutHelper::checkCarrierRestrictionByIdModule(
                        $idModule,
                        $carrier->id_reference
                    )) {
                        unset($paymentMethod[$key]);
                    }
                }
            }
        }
        return $paymentMethod;
    }

    public function displayAjaxAddVoucher()
    {
        $data = array('status' => 'ok');
        $code = trim(Tools::getValue('discountName'));
        if (!$code) {
            $data['msg'] = $this->module->l('You must enter a voucher code', 'wkcheckout');
            $data['status'] = 'ko';
        } elseif (!Validate::isCleanHtml($code)) {
            $data['msg'] = $this->module->l('The voucher code is invalid', 'wkcheckout');
            $data['status'] = 'ko';
        } else {
            if (($cartRule = new CartRule(CartRule::getIdByCode($code))) && Validate::isLoadedObject($cartRule)) {
                if ($error = $cartRule->checkValidity($this->context, false, true)) {
                    $data['msg'] = $error;
                    $data['status'] = 'ko';
                } else {
                    $this->context->cart->addCartRule($cartRule->id);
                }
            } else {
                $data['msg'] = $this->module->l('This voucher does not exist', 'wkcheckout');
                $data['status'] = 'ko';
            }
        }
        die(json_encode($data));
    }

    public function displayAjaxDeleteVoucher()
    {
        if (($id_cart_rule = (int)Tools::getValue('deleteDiscount')) && Validate::isUnsignedId($id_cart_rule)) {
            $this->context->cart->removeCartRule($id_cart_rule);
            CartRule::autoAddToCart($this->context);
            die(json_encode(array('status' => 'ok')));
        }
        die(json_encode(array('status' => 'ko')));
    }

    public function displayAjaxGetState()
    {
        $idCountry = Tools::getValue('idCountry');
        $dataAttr = Tools::getValue('dataAttr');
        $states = State::getStatesByIdCountry($idCountry);
        if ($states) {
            $this->context->smarty->assign('states', $states);
            if ($dataAttr == 'delivery') {
                die($this->context->smarty->fetch(
                    'module:wkonepagecheckout/views/templates/front/content/_partials/wk-delivery-state.tpl'
                ));
            } elseif ($dataAttr == 'invoice') {
                die($this->context->smarty->fetch(
                    'module:wkonepagecheckout/views/templates/front/content/_partials/wk-invoice-state.tpl'
                ));
            }
        }
        die(false);
    }

    public function displayAjaxValidateAddressField()
    {
        $data = array('status' => 'ok');
        $fieldValidation = Tools::getValue('fieldValidation');
        //$fieldId = Tools::getValue('fieldId');
        $fieldValue = Tools::getValue('fieldValue');
        $required = Tools::getValue('required');
        $maxlength = Tools::getValue('maxlength');

        if (!$fieldValue) {
            if ($required) {
                $data['status'] = 'ko';
                $data['msg'] = $this->module->l('Field is required', 'wkcheckout');
            } else {
                $data['msg'] = "";
                $data['status'] = 'ok';
            }
        } elseif ($maxlength && count($fieldValue) > $maxlength) {
            $data['status'] = 'ko';
            $data['msg'] = $this->module->l('Field value is too large', 'wkcheckout');
        } elseif ($fieldValidation && !Validate::$fieldValidation($fieldValue)) {
            $data['status'] = 'ko';
            $data['msg'] = $this->module->l('Field value is not valid', 'wkcheckout');
        }
        die(json_encode($data));
    }

    public function displayAjaxValidateDeliveryFormField()
    {
        $params = array();
        parse_str(Tools::getValue('formData'), $params);
        $dataType = Tools::getValue('dataType');
        $data = array();
        
        $wkFirstName = trim($params['wk_'.$dataType.'_first_name']);
        $wkLastName = trim($params['wk_'.$dataType.'_last_name']);
        $wkAddressInfo = trim($params['wk_'.$dataType.'_address_info']);
        /* Adriana - 15/07/2020 - início */
        $wkNumber = trim($params['wk_'.$dataType.'_address_number']);
        /* Adriana - 15/07/2020 - fim */
        $wkDeliveryAddressCountry = $params['wk_'.$dataType.'_address_country'];

        $wkDeliveryAddress_state = $params['wk_'.$dataType.'_address_state'];
        if (!$wkDeliveryAddress_state) {
            $data['wk_'.$dataType.'_address_state'] = array(
                'status' => 'ko',
                'msg' => $this->module->l('Estate is required', 'wkcheckout'),
                'id' => 'wk_'.$dataType.'_address_state');
        } else {
            $data['wk_'.$dataType.'_address_state'] = array(
                'status' => 'ok',
                'msg' => "",
                'id' => 'wk_'.$dataType.'_address_state');
        }

        $wkAddressCity = trim($params['wk_'.$dataType.'_address_city']);
        $wkAddressZip = trim($params['wk_'.$dataType.'_address_zip']);

        $country = new Country($wkDeliveryAddressCountry);

        if (!$wkFirstName) {
            $data['wk_'.$dataType.'_first_name'] = array(
                'status' => 'ko',
                'msg' => $this->module->l('First name is required', 'wkcheckout'),
                'id' => 'wk_'.$dataType.'_first_name');
        } elseif (!Validate::isName($wkFirstName)) {
            $data['wk_'.$dataType.'_first_name'] = array(
                'status' => 'ko',
                'msg' => $this->module->l('First name is not valid', 'wkcheckout'),
                'id' => 'wk_'.$dataType.'_first_name');
        } else {
            $data['wk_'.$dataType.'_first_name'] = array(
                'status' => 'ok',
                'msg' => "",
                'id' => 'wk_'.$dataType.'_first_name');
        }

        if (!$wkLastName) {
            $data['wk_'.$dataType.'_last_name'] = array(
                'status' => 'ko',
                'msg' => $this->module->l('Last name is required', 'wkcheckout'),
                'id' => 'wk_'.$dataType.'_last_name');
        } elseif (!Validate::isName($wkLastName)) {
            $data['wk_'.$dataType.'_last_name'] = array(
                'status' => 'ko',
                'msg' => $this->module->l('Last name is not valid', 'wkcheckout'),
                'id' => 'wk_'.$dataType.'_last_name');
        } else {
            $data['wk_'.$dataType.'_last_name'] = array(
                'status' => 'ok',
                'msg' => "",
                'id' => 'wk_'.$dataType.'_last_name');
        }

        if (isset($params['wk_'.$dataType.'_dni_info'])) {
            $wkDniInfo = trim($params['wk_'.$dataType.'_dni_info']);
            if (!Validate::isGenericName($wkDniInfo)) {
                $data['wk_'.$dataType.'_dni_info'] = array(
                    'status' => 'ko',
                    'msg' => $this->module->l('Dni is not valid', 'wkcheckout'),
                    'id' => 'wk_'.$dataType.'_dni_info'
                );
            } elseif (!Validate::isDniLite($wkDniInfo)) {
                    $data['wk_'.$dataType.'_dni_info'] = array(
                        'status' => 'ko',
                        'msg' => $this->module->l('Dni is not valid', 'wkcheckout'),
                        'id' => 'wk_'.$dataType.'_dni_info'
                    );
            } else {
                $data['wk_'.$dataType.'_dni_info'] = array(
                    'status' => 'ok',
                    'msg' => "",
                    'id' => 'wk_'.$dataType.'_dni_info');
            }
        }
        if ($dataType == 'delivery' && Configuration::get('WK_CHECKOUT_DELIVERY_DNI_REQ') && !$wkDniInfo) {
            $data['wk_'.$dataType.'_dni_info'] = array(
                'status' => 'ko',
                'msg' => $this->module->l('Dni field is required', 'wkcheckout'),
                'id' => 'wk_'.$dataType.'_dni_info'
            );
        } else {
            $data['wk_'.$dataType.'_dni_info'] = array(
                'status' => 'ok',
                'msg' => "",
                'id' => 'wk_'.$dataType.'_dni_info');
        }

        if ($dataType == 'invoice' && Configuration::get('WK_CHECKOUT_INVOICE_DNI_REQ') && !$wkDniInfo) {
            $data['wk_'.$dataType.'_dni_info'] = array(
                'status' => 'ko',
                'msg' => $this->module->l('Dni field is required', 'wkcheckout'),
                'id' => 'wk_'.$dataType.'_dni_info'
            );
        } else {
            $data['wk_'.$dataType.'_dni_info'] = array(
                'status' => 'ok',
                'msg' => "",
                'id' => 'wk_'.$dataType.'_dni_info');
        }

        if (!$wkAddressZip) {
            $data['wk_'.$dataType.'_address_zip'] = array(
                'status' => 'ko',
                'msg' => $this->module->l('Zip code is required', 'wkcheckout'),
                'id' => 'wk_'.$dataType.'_address_zip');
        } elseif (!Validate::isPostCode($wkAddressZip)) {
            $data['wk_'.$dataType.'_address_zip'] = array(
                'status' => 'ko',
                'msg' => $this->module->l('Zip code is not valid', 'wkcheckout'),
                'id' => 'wk_'.$dataType.'_address_zip');
        } elseif (!$country->checkZipCode(str_replace("-","","$wkAddressZip"))) {
            $data['wk_'.$dataType.'_address_zip'] = array(
                'status' => 'ko',
                'msg' => sprintf(
                    $this->module->l('Invalid postcode - should look like "%1$s"', 'wkcheckout'),
                    $country->zip_code_format
                ),
                'id' => 'wk_'.$dataType.'_address_zip');
        } else {
            $data['wk_'.$dataType.'_address_zip'] = array(
                'status' => 'ok',
                'msg' => "",
                'id' => 'wk_'.$dataType.'_address_zip');
        }

        if (!$wkAddressInfo) {
            $data['wk_'.$dataType.'_address_info'] = array(
                'status' => 'ko',
                'msg' => $this->module->l('Address field is required', 'wkcheckout'),
                'id' => 'wk_'.$dataType.'_address_info');
        } elseif (!Validate::isAddress($wkAddressInfo)) {
            $data['wk_'.$dataType.'_address_info'] = array(
                'status' => 'ko',
                'msg' => $this->module->l('Address field is not valid', 'wkcheckout'),
                'id' => 'wk_'.$dataType.'_address_info');
        } else {
            $data['wk_'.$dataType.'_address_info'] = array(
                'status' => 'ok',
                'msg' => "",
                'id' => 'wk_'.$dataType.'_address_info');
        }

        /* Adriana - 15/07/2020 - início */
        if ($dataType == 'delivery') {
            if (Configuration::get('WK_CHECKOUT_DELIVERY_NUMBER_REQ')
            && !$wkNumber) {
                $data['wk_'.$dataType.'_address_number'] = array(
                    'status' => 'ko',
                    'msg' => $this->module->l('Number is required', 'wkcheckout'),
                    'id' => 'wk_'.$dataType.'_address_number'
                );
            } else {
                $data['wk_'.$dataType.'_address_number'] = array(
                    'status' => 'ok',
                    'msg' => "",
                    'id' => 'wk_'.$dataType.'_address_number');
            }
        } elseif ($dataType == 'invoice') {
            if (Configuration::get('WK_CHECKOUT_INVOICE_NUMBER_REQ')
            && !$wkNumber) {
                $data['wk_'.$dataType.'_address_number'] = array(
                    'status' => 'ko',
                    'msg' => $this->module->l('Number is required', 'wkcheckout'),
                    'id' => 'wk_'.$dataType.'_address_number'
                );
            } else {
                $data['wk_'.$dataType.'_address_number'] = array(
                    'status' => 'ok',
                    'msg' => "",
                    'id' => 'wk_'.$dataType.'_address_number');
            }
        }
        /* Adriana - 15/07/2020 - fim */

        if (isset($params['wk_'.$dataType.'_address_other_information'])) {
            $wkOther = trim($params['wk_'.$dataType.'_address_other_information']);
            if (!Validate::isMessage($wkOther)) {
                $data['wk_'.$dataType.'_address_other_information'] = array(
                    'status' => 'ko',
                    'msg' => $this->module->l('Other information is not valid', 'wkcheckout'),
                    'id' => 'wk_'.$dataType.'_address_other_information'
                );
                /* Adriana - 15/07/2020 - início */
                /*
                } elseif ($dataType == 'delivery'
                && Configuration::get('WK_CHECKOUT_DELIVERY_PHONE_REQ')
                && !$wkOther) {
                    $data['wk_'.$dataType.'_address_other_information'] = array(
                        'status' => 'ko',
                        'msg' => $this->module->l('Other information is required', 'wkcheckout'),
                        'id' => 'wk_'.$dataType.'_address_other_information'
                    );
                } elseif ($dataType == 'invoice'
                && Configuration::get('WK_CHECKOUT_INVOICE_PHONE_REQ')
                && !$wkOther) {
                    $data['wk_'.$dataType.'_address_other_information'] = array(
                        'status' => 'ko',
                        'msg' => $this->module->l('Other information is required', 'wkcheckout'),
                        'id' => 'wk_'.$dataType.'_address_other_information'
                    );
                }
                */
            } elseif ($dataType == 'delivery' 
                && Configuration::get('WK_CHECKOUT_DELIVERY_OTHER_REQ')
                && !$wkOther) {
                $data['wk_'.$dataType.'_address_other_information'] = array(
                    'status' => 'ko',
                    'msg' => $this->module->l('Other information is required', 'wkcheckout'),
                    'id' => 'wk_'.$dataType.'_address_other_information'
                );
            } elseif ($dataType == 'invoice'
                && Configuration::get('WK_CHECKOUT_INVOICE_OTHER_REQ')
                && !$wkOther) {
                $data['wk_'.$dataType.'_address_other_information'] = array(
                    'status' => 'ko',
                    'msg' => $this->module->l('Other information is required', 'wkcheckout'),
                    'id' => 'wk_'.$dataType.'_address_other_information'
                );
            } else {
                $data['wk_'.$dataType.'_address_other_information'] = array(
                    'status' => 'ok',
                    'msg' => "",
                    'id' => 'wk_'.$dataType.'_address_other_information');
            }
            /* Adriana - 15/07/2020 - fim */
        }

        if (isset($params['wk_'.$dataType.'_address_complement'])) {
            $wkAddressComplement = trim($params['wk_'.$dataType.'_address_complement']);
            if (!Validate::isAddress($wkAddressComplement)) {
                $data['wk_'.$dataType.'_address_complement'] = array(
                    'status' => 'ko',
                    'msg' => $this->module->l('Address complement field is not valid', 'wkcheckout'),
                    'id' => 'wk_'.$dataType.'_address_complement'
                );
                /* Adriana - 15/07/2020 - início */
                /*
                    } elseif ($dataType == 'delivery'
                    && Configuration::get('WK_CHECKOUT_DELIVERY_ADDRESS_COMPANY_REQ')
                    && !$wkAddressComplement) {
                        $data['wk_'.$dataType.'_address_complement'] = array(
                            'status' => 'ko',
                            'msg' => $this->module->l('Address complement field is required', 'wkcheckout'),
                            'id' => 'wk_'.$dataType.'_address_complement'
                        );
                    } elseif ($dataType == 'invoice'
                    && Configuration::get('WK_CHECKOUT_INVOICE_ADDRESS_COMPANY_REQ')
                    && !$wkAddressComplement) {
                        $data['wk_'.$dataType.'_address_complement'] = array(
                            'status' => 'ko',
                            'msg' => $this->module->l('Address complement field is required', 'wkcheckout'),
                            'id' => 'wk_'.$dataType.'_address_complement'
                        );
                    }
                */
            } elseif ($dataType == 'delivery'
                && Configuration::get('WK_CHECKOUT_DELIVERY_ADDRESS_COMPLEM_REQ')
                && !$wkAddressComplement) {
                $data['wk_'.$dataType.'_address_complement'] = array(
                    'status' => 'ko',
                    'msg' => $this->module->l('Address complement field is required', 'wkcheckout'),
                    'id' => 'wk_'.$dataType.'_address_complement'
                );
            } elseif ($dataType == 'invoice'
                && Configuration::get('WK_CHECKOUT_INVOICE_ADDRESS_COMPLEM_REQ')
                && !$wkAddressComplement) {
                $data['wk_'.$dataType.'_address_complement'] = array(
                    'status' => 'ko',
                    'msg' => $this->module->l('Address complement field is required', 'wkcheckout'),
                    'id' => 'wk_'.$dataType.'_address_complement'
                );
            } else {
                $data['wk_'.$dataType.'_address_complement'] = array(
                    'status' => 'ok',
                    'msg' => "",
                    'id' => 'wk_'.$dataType.'_address_complement');
            }
            /* Adriana - 15/07/2020 - fim */
        }

        if (!$wkAddressCity) {
            $data['wk_'.$dataType.'_address_city'] = array(
                'status' => 'ko',
                'msg' => $this->module->l('City is required', 'wkcheckout'),
                'id' => 'wk_'.$dataType.'_address_city');
        } elseif (!Validate::isCityName($wkAddressCity)) {
            $data['wk_'.$dataType.'_address_city'] = array(
                'status' => 'ko',
                'msg' => $this->module->l('City is not valid', 'wkcheckout'),
                'id' => 'wk_'.$dataType.'_address_city');
        } else {
            $data['wk_'.$dataType.'_address_city'] = array(
                'status' => 'ok',
                'msg' => "",
                'id' => 'wk_'.$dataType.'_address_city');
        }

        if (isset($params['wk_'.$dataType.'_address_mobile_phone'])) {
            $wkMobilePhone = trim($params['wk_'.$dataType.'_address_mobile_phone']);
            if (!Validate::isPhoneNumber($wkMobilePhone)) {
                $data['wk_'.$dataType.'_address_mobile_phone'] = array(
                    'status' => 'ko',
                    'msg' => $this->module->l('Mobile Phone number is not valid', 'wkcheckout'),
                    'id' => 'wk_'.$dataType.'_address_mobile_phone'
                );
            } elseif ($dataType == 'delivery'
                // Adriana - 15/07/2020 - início
                //&& Configuration::get('WK_CHECKOUT_DELIVERY_PHONE_REQ')
                && Configuration::get('WK_CHECKOUT_DELIVERY_MOBILE_PHONE_REQ')
                // Adriana - 15/07/2020 - fim
                && !$wkMobilePhone) {
                $data['wk_'.$dataType.'_address_mobile_phone'] = array(
                    'status' => 'ko',
                    'msg' => $this->module->l('Mobile Phone number is required', 'wkcheckout'),
                    'id' => 'wk_'.$dataType.'_address_mobile_phone'
                );
            } elseif ($dataType == 'invoice'
                // Adriana - 15/07/2020 - início
                //&& Configuration::get('WK_CHECKOUT_INVOICE_PHONE_REQ')
                //&& Configuration::get('WK_CHECKOUT_INVOICE_MOBILE_PHONE_REQ')
                // Adriana - 15/07/2020 - fim
                && !$wkMobilePhone) {
                $data['wk_'.$dataType.'_address_mobile_phone'] = array(
                    'status' => 'ko',
                    'msg' => $this->module->l('Mobile Phone number is required', 'wkcheckout'),
                    'id' => 'wk_'.$dataType.'_address_mobile_phone'
                );
            } else {
                $data['wk_'.$dataType.'_address_mobile_phone'] = array(
                    'status' => 'ok',
                    'msg' => "",
                    'id' => 'wk_'.$dataType.'_address_mobile_phone');
            }
        }

        // These are optional fields to create an address
        if (isset($params['wk_'.$dataType.'_address_alias'])) {
            $wkAlias = trim($params['wk_'.$dataType.'_address_alias']);
            if (!Validate::isGenericName($wkAlias)) {
                $data['wk_'.$dataType.'_address_alias'] = array(
                    'status' => 'ko',
                    'msg' => $this->module->l('Address alias is not valid', 'wkcheckout'),
                    'id' => 'wk_'.$dataType.'_address_alias'
                );
            } elseif ($dataType == 'delivery' && Configuration::get('WK_CHECKOUT_DELIVERY_ALIAS_REQ') && !$wkAlias) {
                $data['wk_'.$dataType.'_address_alias'] = array(
                    'status' => 'ko',
                    'msg' => $this->module->l('Address alias is required', 'wkcheckout'),
                    'id' => 'wk_'.$dataType.'_address_alias'
                );
            } elseif ($dataType == 'invoice' && Configuration::get('WK_CHECKOUT_INVOICE_ALIAS_REQ') && !$wkAlias) {
                $data['wk_'.$dataType.'_address_alias'] = array(
                    'status' => 'ko',
                    'msg' => $this->module->l('Address alias is required', 'wkcheckout'),
                    'id' => 'wk_'.$dataType.'_address_alias'
                );
            } else {
                $data['wk_'.$dataType.'_address_alias'] = array(
                    'status' => 'ok',
                    'msg' => "",
                    'id' => 'wk_'.$dataType.'_address_alias');
            }
        }

        if (isset($params['wk_'.$dataType.'_company_name'])) {
            $wkCompanyName = trim($params['wk_'.$dataType.'_company_name']);
            if (!Validate::isGenericName($wkCompanyName)) {
                $data['wk_'.$dataType.'_company_name'] = array(
                    'status' => 'ko',
                    'msg' => $this->module->l('Company field is not valid', 'wkcheckout'),
                    'id' => 'wk_'.$dataType.'_company_name'
                );
            } elseif ($dataType == 'delivery'
            && Configuration::get('WK_CHECKOUT_DELIVERY_COMPANY_REQ')
            && !$wkCompanyName) {
                $data['wk_'.$dataType.'_company_name'] = array(
                    'status' => 'ko',
                    'msg' => $this->module->l('Company field is required', 'wkcheckout'),
                    'id' => 'wk_'.$dataType.'_company_name'
                );
            } elseif ($dataType == 'invoice'
            && Configuration::get('WK_CHECKOUT_INVOICE_COMPANY_REQ')
            && !$wkCompanyName) {
                $data['wk_'.$dataType.'_company_name'] = array(
                    'status' => 'ko',
                    'msg' => $this->module->l('Company field is required', 'wkcheckout'),
                    'id' => 'wk_'.$dataType.'_company_name'
                );
            } else {
                $data['wk_'.$dataType.'_company_name'] = array(
                    'status' => 'ok',
                    'msg' => "",
                    'id' => 'wk_'.$dataType.'_company_name');
            }
        }

        if (isset($params['wk_'.$dataType.'_address_phone'])) {
            $wkPhone = trim($params['wk_'.$dataType.'_address_phone']);
            if (!Validate::isPhoneNumber($wkPhone)) {
                $data['wk_'.$dataType.'_address_phone'] = array(
                    'status' => 'ko',
                    'msg' => $this->module->l('Phone number is not valid', 'wkcheckout'),
                    'id' => 'wk_'.$dataType.'_address_phone'
                );
            } elseif ($dataType == 'delivery'
                && Configuration::get('WK_CHECKOUT_DELIVERY_PHONE_REQ')
                && !$wkPhone) {
                $data['wk_'.$dataType.'_address_phone'] = array(
                    'status' => 'ko',
                    'msg' => $this->module->l('Phone number is required', 'wkcheckout'),
                    'id' => 'wk_'.$dataType.'_address_phone'
                );
            } elseif ($dataType == 'invoice'
                && Configuration::get('WK_CHECKOUT_INVOICE_PHONE_REQ')
                && !$wkPhone) {
                $data['wk_'.$dataType.'_address_phone'] = array(
                    'status' => 'ko',
                    'msg' => $this->module->l('Phone number is required', 'wkcheckout'),
                    'id' => 'wk_'.$dataType.'_address_phone'
                );
            } else {
                $data['wk_'.$dataType.'_address_phone'] = array(
                    'status' => 'ok',
                    'msg' => "",
                    'id' => 'wk_'.$dataType.'_address_phone');
            }
        }

        if (empty($data)) {
            die(json_encode(false));
        } else {
            die(json_encode($data));
        }
    }

    public function displayAjaxCheckPostalCode()
    {
        $data = array();
        $idCountry = Tools::getValue('idCountry');
        $postalCode = Tools::getValue('fieldValue');
        $fieldId = Tools::getValue('fieldId');
        $country = new Country($idCountry);

        if (!$postalCode) {
            $data = array(
                'status' => 'ko',
                'msg' => $this->module->l('Zip code is required', 'wkcheckout'),
                'id' => $fieldId);
        } elseif (!Validate::isPostCode($postalCode)) {
            $data = array(
                'status' => 'ko',
                'msg' => $this->module->l('Zip code is not valid', 'wkcheckout'),
                'id' => $fieldId);
        /* Adriana - 31/05/2021 - início */
        //} elseif (!$country->checkZipCode($postalCode)) {
        } elseif (!$country->checkZipCode(str_replace("-","",$postalCode))) {
        /* Adriana - 31/05/2021 - fim */
            $data = array(
                'status' => 'ko',
                'msg' => sprintf(
                    $this->module->l('Invalid postcode - should look like "%1$s"', 'wkcheckout'),
                    $country->zip_code_format
                ),
                'id' => $fieldId);
        }
        if (empty($data)) {
            die(json_encode(false));
        } else {
            die(json_encode($data));
        }
    }

    public function displayAjaxCreateAddress() 
    {
        $params = array();
        parse_str(Tools::getValue('formData'), $params);
        $dataType = Tools::getValue('dataType');

        if ($dataType == 'delivery') {
            $idAddress = trim($params['id-new-delivery-address']);
        } else {
            $idAddress = trim($params['id-new-invoice-address']);
        }

        // These are mandory fields to create an address
        $wkFirstName = trim($params['wk_'.$dataType.'_first_name']);
        $wkLastName = trim($params['wk_'.$dataType.'_last_name']);
        $wkAddress = trim($params['wk_'.$dataType.'_address_info']);
        /* Adriana - 15/07/2020 - início */
        $wkAddress2 = trim($params['wk_'.$dataType.'_address_complement']);
        /* Adriana - 15/07/2020 - fim */
        $wkCountry = $params['wk_'.$dataType.'_address_country'];
        $wkCity = trim($params['wk_'.$dataType.'_address_city']);
        $wkPostCode = trim($params['wk_'.$dataType.'_address_zip']);

        $address = new Address();
        if ($idAddress) {
            $address = new Address($idAddress);
        }

        $address->id_customer = $this->context->customer->id;
        $address->firstname = $wkFirstName;
        $address->lastname = $wkLastName;
        /* Adriana - 15/07/2020 - início */
        $wkState = 0;
        if (isset($params['wk_'.$dataType.'_address_state'])) {
            $wkState = $params['wk_'.$dataType.'_address_state'];
        }

        if (isset($params['wk_'.$dataType.'_dni_info'])) {
            $address->dni = trim($params['wk_'.$dataType.'_dni_info']);
        }
        if (isset($params['wk_'.$dataType.'_address_number'])) {
            $address->number = trim($params['wk_'.$dataType.'_address_number']);
        } 
        if (isset($params['wk_'.$dataType.'_address_mobile_phone'])) {
            $address->phone_mobile = trim($params['wk_'.$dataType.'_address_mobile_phone']);
        }
        /* Adriana - 15/07/2020 - fim */
        $address->address1 = $wkAddress;
        $address->address2 = $wkAddress2;
        $address->id_country = $wkCountry;
        $address->id_state = $wkState;
        $address->city = $wkCity;
        $address->postcode = $wkPostCode;

        // $address->dni = 1;
        // These are optional fields to create an address
        if (isset($params['wk_'.$dataType.'_address_alias']) && $params['wk_'.$dataType.'_address_alias']) {
            $address->alias = trim($params['wk_'.$dataType.'_address_alias']);
        } else {
            $address->alias = $this->module->l('My address', 'wkcheckout');
        }
        if (isset($params['wk_'.$dataType.'_company_name'])) {
            $address->company = trim($params['wk_'.$dataType.'_company_name']);
        }
        /* Adriana - 15/07/2020 - início */
        /*
        if (isset($params['wk_'.$dataType.'_address_complement'])) {
            $address->address2 = trim($params['wk_'.$dataType.'_address_complement']);
        }
        */
        /* Adriana - 15/07/2020 - fim */
        if (isset($params['wk_'.$dataType.'_address_phone'])) {
            $address->phone = trim($params['wk_'.$dataType.'_address_phone']);
        }
        if (isset($params['wk_'.$dataType.'_address_other_information'])) {
            $address->other = trim($params['wk_'.$dataType.'_address_other_information']);
        }
        if ($address->save()) {
            if ($dataType == 'delivery') {
                $this->updateAddressIntoCart($address->id, $this->context->cart->id_address_invoice);
            } else {
                $this->updateAddressIntoCart($this->context->cart->id_address_delivery, $address->id);
            }

            $states = State::getStatesByIdCountry($address->id_country);
            if ($states) {
                $this->context->smarty->assign('states', $states);
            }
            // dump($this->context->customer['addresses']);
            $this->context->smarty->assign(array(
                'delivery_address' => new Address($address->id),
                'countries' => Country::getCountries($this->context->language->id, true),
                'states' => State::getStatesByIdCountry($address->id_country),
            ));

            if ($dataType == 'delivery') {
                die($this->context->smarty->fetch(
                    'module:wkonepagecheckout/views/templates/front/content/_partials/wk_delivery_address.tpl'
                ));
            } else {
                die($this->context->smarty->fetch(
                    'module:wkonepagecheckout/views/templates/front/content/_partials/wk_invoice_address.tpl'
                ));
            }
        } else {
            die(false);
        }
    }

    public function displayAjaxUpdateFooter()
    {
        $products = $this->module->processWhoBoughtAlsoBought();
        if (!empty($products)) {
            $this->context->smarty->assign(array(
                'products' => $products,
            ));
            die($this->context->smarty->fetch('module:wkonepagecheckout/views/templates/hook/wk-also-bought.tpl'));
        } else {
            die(false);
        }
    }

    public function getPackageListByIdCountry($idCountry, $idState, $flush = false)
    {
        $cart = new Cart((int) $this->context->cart->id);

        $product_list = $cart->getProducts($flush);
        // Step 1 : Get product informations (warehouse_list and carrier_list), count warehouse
        // Determine the best warehouse to determine the packages
        // For that we count the number of time we can use a warehouse for a specific delivery address
        $warehouse_count_by_address = array();

        $stock_management_active = Configuration::get('PS_ADVANCED_STOCK_MANAGEMENT');

        foreach ($product_list as &$product) {
            if ((int)$product['id_address_delivery'] == 0) {
                $product['id_address_delivery'] = (int)$cart->id_address_delivery;
            }

            if (!isset($warehouse_count_by_address[$product['id_address_delivery']])) {
                $warehouse_count_by_address[$product['id_address_delivery']] = array();
            }

            $product['warehouse_list'] = array();

            if ($stock_management_active &&
                (int)$product['advanced_stock_management'] == 1) {
                $warehouse_list = Warehouse::getProductWarehouseList(
                    $product['id_product'],
                    $product['id_product_attribute'],
                    $cart->id_shop
                );
                if (count($warehouse_list) == 0) {
                    $warehouse_list = Warehouse::getProductWarehouseList(
                        $product['id_product'],
                        $product['id_product_attribute']
                    );
                }
                // Does the product is in stock ?
                // If yes, get only warehouse where the product is in stock

                $warehouse_in_stock = array();
                $manager = StockManagerFactory::getManager();

                foreach ($warehouse_list as $key => $warehouse) {
                    $product_real_quantities = $manager->getProductRealQuantities(
                        $product['id_product'],
                        $product['id_product_attribute'],
                        array($warehouse['id_warehouse']),
                        true
                    );

                    if ($product_real_quantities > 0 || Pack::isPack((int)$product['id_product'])) {
                        $warehouse_in_stock[] = $warehouse;
                    }
                }

                if (!empty($warehouse_in_stock)) {
                    $warehouse_list = $warehouse_in_stock;
                    $product['in_stock'] = true;
                } else {
                    $product['in_stock'] = false;
                }
            } else {
                //simulate default warehouse
                $warehouse_list = array(0 => array('id_warehouse' => 0));
                $product['in_stock'] = StockAvailable::getQuantityAvailableByProduct(
                    $product['id_product'],
                    $product['id_product_attribute']
                ) > 0;
            }

            foreach ($warehouse_list as $warehouse) {
                $product['warehouse_list'][$warehouse['id_warehouse']] = $warehouse['id_warehouse'];
                if (!isset($warehouse_count_by_address[$product['id_address_delivery']][$warehouse['id_warehouse']])) {
                    $warehouse_count_by_address[$product['id_address_delivery']][$warehouse['id_warehouse']] = 0;
                }

                $warehouse_count_by_address[$product['id_address_delivery']][$warehouse['id_warehouse']]++;
            }
        }
        unset($product);

        arsort($warehouse_count_by_address);

        // Step 2 : Group product by warehouse
        $grouped_by_warehouse = array();

        foreach ($product_list as &$product) {
            if (!isset($grouped_by_warehouse[$product['id_address_delivery']])) {
                $grouped_by_warehouse[$product['id_address_delivery']] = array(
                    'in_stock' => array(),
                    'out_of_stock' => array(),
                );
            }

            $product['carrier_list'] = array();
            $id_warehouse = 0;
            foreach ($warehouse_count_by_address[$product['id_address_delivery']] as $id_war => $val) {
                if (array_key_exists((int) $id_war, $product['warehouse_list']) && $val) {
                    $product['carrier_list'] = Tools::array_replace(
                        $product['carrier_list'],
                        $this->getAvailableCarrierList(
                            new Product($product['id_product']),
                            $id_war,
                            $idCountry,
                            $idState,
                            null,
                            $cart
                        )
                    );
                    if (!$id_warehouse) {
                        $id_warehouse = (int)$id_war;
                    }
                }
            }

            if (!isset($grouped_by_warehouse[$product['id_address_delivery']]['in_stock'][$id_warehouse])) {
                $grouped_by_warehouse[$product['id_address_delivery']]['in_stock'][$id_warehouse] = array();
                $grouped_by_warehouse[$product['id_address_delivery']]['out_of_stock'][$id_warehouse] = array();
            }

            if (!$cart->allow_seperated_package) {
                $key = 'in_stock';
            } else {
                $key = $product['in_stock'] ? 'in_stock' : 'out_of_stock';
                $product_quantity_in_stock = StockAvailable::getQuantityAvailableByProduct(
                    $product['id_product'],
                    $product['id_product_attribute']
                );
                if ($product['in_stock'] && $product['cart_quantity'] > $product_quantity_in_stock) {
                    $out_stock_part = $product['cart_quantity'] - $product_quantity_in_stock;
                    $product_bis = $product;
                    $product_bis['cart_quantity'] = $out_stock_part;
                    $product_bis['in_stock'] = 0;
                    $product['cart_quantity'] -= $out_stock_part;
                    $grouped_by_warehouse[$product['id_address_delivery']]['out_of_stock'][$id_warehouse][] =
                    $product_bis;
                }
            }

            if (empty($product['carrier_list'])) {
                $product['carrier_list'] = array(0 => 0);
            }

            $grouped_by_warehouse[$product['id_address_delivery']][$key][$id_warehouse][] = $product;
        }
        unset($product);

        // Step 3 : grouped product from grouped_by_warehouse by available carriers
        $grouped_by_carriers = array();
        foreach ($grouped_by_warehouse as $id_address_delivery => $products_in_stock_list) {
            if (!isset($grouped_by_carriers[$id_address_delivery])) {
                $grouped_by_carriers[$id_address_delivery] = array(
                    'in_stock' => array(),
                    'out_of_stock' => array(),
                );
            }
            foreach ($products_in_stock_list as $key => $warehouse_list) {
                if (!isset($grouped_by_carriers[$id_address_delivery][$key])) {
                    $grouped_by_carriers[$id_address_delivery][$key] = array();
                }
                foreach ($warehouse_list as $id_warehouse => $product_list) {
                    if (!isset($grouped_by_carriers[$id_address_delivery][$key][$id_warehouse])) {
                        $grouped_by_carriers[$id_address_delivery][$key][$id_warehouse] = array();
                    }
                    foreach ($product_list as $product) {
                        $pack_key = implode(',', $product['carrier_list']);

                        if (!isset($grouped_by_carriers[$id_address_delivery][$key][$id_warehouse][$pack_key])) {
                            $grouped_by_carriers[$id_address_delivery][$key][$id_warehouse][$pack_key] = array(
                                'product_list' => array(),
                                'carrier_list' => $product['carrier_list'],
                                'warehouse_list' => $product['warehouse_list']
                            );
                        }

                        $grouped_by_carriers[$id_address_delivery][$key][$id_warehouse][$pack_key]['product_list'][] =
                        $product;
                    }
                }
            }
        }

        $package_list = array();
        // Step 4 : merge product from grouped_by_carriers into $package to minimize the number of package
        foreach ($grouped_by_carriers as $id_address_delivery => $products_in_stock_list) {
            if (!isset($package_list[$id_address_delivery])) {
                $package_list[$id_address_delivery] = array(
                    'in_stock' => array(),
                    'out_of_stock' => array(),
                );
            }

            foreach ($products_in_stock_list as $key => $warehouse_list) {
                if (!isset($package_list[$id_address_delivery][$key])) {
                    $package_list[$id_address_delivery][$key] = array();
                }
                // Count occurance of each carriers to minimize the number of packages
                $carrier_count = array();
                foreach ($warehouse_list as $id_warehouse => $products_grouped_by_carriers) {
                    foreach ($products_grouped_by_carriers as $data) {
                        foreach ($data['carrier_list'] as $id_carrier) {
                            if (!isset($carrier_count[$id_carrier])) {
                                $carrier_count[$id_carrier] = 0;
                            }
                            $carrier_count[$id_carrier]++;
                        }
                    }
                }
                arsort($carrier_count);
                foreach ($warehouse_list as $id_warehouse => $products_grouped_by_carriers) {
                    if (!isset($package_list[$id_address_delivery][$key][$id_warehouse])) {
                        $package_list[$id_address_delivery][$key][$id_warehouse] = array();
                    }
                    foreach ($products_grouped_by_carriers as $data) {
                        foreach ($carrier_count as $id_c => $rate) {
                            if (array_key_exists($id_c, $data['carrier_list']) && $rate) {
                                if (!isset($package_list[$id_address_delivery][$key][$id_warehouse][$id_c])) {
                                    $package_list[$id_address_delivery][$key][$id_warehouse][$id_c] = array(
                                        'carrier_list' => $data['carrier_list'],
                                        'warehouse_list' => $data['warehouse_list'],
                                        'product_list' => array(),
                                    );
                                }
                                $package_list[$id_address_delivery][$key][$id_warehouse][$id_c]['carrier_list'] =
                                    array_intersect(
                                        $package_list[$id_address_delivery][$key][$id_warehouse][$id_c]['carrier_list'],
                                        $data['carrier_list']
                                    );
                                $package_list[$id_address_delivery][$key][$id_warehouse][$id_c]['product_list'] =
                                    array_merge(
                                        $package_list[$id_address_delivery][$key][$id_warehouse][$id_c]['product_list'],
                                        $data['product_list']
                                    );

                                break;
                            }
                        }
                    }
                }
            }
        }

        // Step 5 : Reduce depth of $package_list
        $final_package_list = array();
        foreach ($package_list as $id_address_delivery => $products_in_stock_list) {
            if (!isset($final_package_list[$id_address_delivery])) {
                $final_package_list[$id_address_delivery] = array();
            }

            foreach ($products_in_stock_list as $key => $warehouse_list) {
                foreach ($warehouse_list as $id_warehouse => $products_grouped_by_carriers) {
                    foreach ($products_grouped_by_carriers as $data) {
                        $final_package_list[$id_address_delivery][] = array(
                            'product_list' => $data['product_list'],
                            'carrier_list' => $data['carrier_list'],
                            'warehouse_list' => $data['warehouse_list'],
                            'id_warehouse' => $id_warehouse,
                        );
                    }
                }
            }
        }

        return $final_package_list;
    }

    public function getAvailableCarrierList(
        Product $product,
        $id_warehouse,
        $idCountry = null,
        $idState = null,
        $id_shop = null,
        $cart = null,
        &$error = array()
    ) {
        static $ps_country_default = null;

        if ($ps_country_default === null) {
            $ps_country_default = Configuration::get('PS_COUNTRY_DEFAULT');
        }

        if (is_null($id_shop)) {
            $id_shop = Context::getContext()->shop->id;
        }
        if (is_null($cart)) {
            $cart = Context::getContext()->cart;
        }

        if (is_null($error) || !is_array($error)) {
            $error = array();
        }

        $id_zone = Country::getIdZone($idCountry);
        if ($idState) {
            $id_zone = State::getIdZone($idState);
        }
        /*$id_address = (int) $idCountry;
        if ($id_address) {
            $id_zone = Address::getZoneById($id_address);

            // Check the country of the address is activated
            if (!Address::isCountryActiveById($id_address)) {
                return array();
            }
        } else {
            $country = new Country($ps_country_default);
            $id_zone = $country->id_zone;
        }*/

        // Does the product is linked with carriers?
        $cache_id = 'Carrier::getAvailableCarrierList_'.(int) $product->id.'-'.(int) $id_shop;
        if (!Cache::isStored($cache_id)) {
            $query = new DbQuery();
            $query->select('id_carrier');
            $query->from('product_carrier', 'pc');
            $query->innerJoin(
                'carrier',
                'c',
                'c.id_reference = pc.id_carrier_reference AND c.deleted = 0 AND c.active = 1'
            );
            $query->where('pc.id_product = '.(int) $product->id);
            $query->where('pc.id_shop = '.(int) $id_shop);

            $carriers_for_product = Db::getInstance(_PS_USE_SQL_SLAVE_)->executeS($query);
            Cache::store($cache_id, $carriers_for_product);
        } else {
            $carriers_for_product = Cache::retrieve($cache_id);
        }

        $carrier_list = array();
        if (!empty($carriers_for_product)) {
            //the product is linked with carriers
            foreach ($carriers_for_product as $carrier) { //check if the linked carriers are available in current zone
                if (Carrier::checkCarrierZone($carrier['id_carrier'], $id_zone)) {
                    $carrier_list[$carrier['id_carrier']] = $carrier['id_carrier'];
                }
            }
            if (empty($carrier_list)) {
                return array();
            }//no linked carrier are available for this zone
        }

        // The product is not directly linked with a carrier
        // Get all the carriers linked to a warehouse
        if ($id_warehouse) {
            $warehouse = new Warehouse($id_warehouse);
            $warehouse_carrier_list = $warehouse->getCarriers();
        }

        $available_carrier_list = array();
        $cache_id = 'Carrier::getAvailableCarrierList_getCarriersForOrder_'.(int) $id_zone.'-'.(int) $cart->id;
        if (!Cache::isStored($cache_id)) {
            $customer = new Customer($cart->id_customer);
            $carrier_error = array();
            $carriers = Carrier::getCarriersForOrder($id_zone, $customer->getGroups(), $cart, $carrier_error);
            Cache::store($cache_id, array($carriers, $carrier_error));
        } else {
            list($carriers, $carrier_error) = Cache::retrieve($cache_id);
        }

        $error = array_merge($error, $carrier_error);

        foreach ($carriers as $carrier) {
            $available_carrier_list[$carrier['id_carrier']] = $carrier['id_carrier'];
        }

        if ($carrier_list) {
            $carrier_list = array_intersect($available_carrier_list, $carrier_list);
        } else {
            $carrier_list = $available_carrier_list;
        }

        if (isset($warehouse_carrier_list)) {
            $carrier_list = array_intersect($carrier_list, $warehouse_carrier_list);
        }

        $cart_quantity = 0;
        $cart_weight = 0;

        foreach ($cart->getProducts(false, false) as $cart_product) {
            if ($cart_product['id_product'] == $product->id) {
                $cart_quantity += $cart_product['cart_quantity'];
            }
            if (isset($cart_product['weight_attribute']) && $cart_product['weight_attribute'] > 0) {
                $cart_weight += ($cart_product['weight_attribute'] * $cart_product['cart_quantity']);
            } else {
                $cart_weight += ($cart_product['weight'] * $cart_product['cart_quantity']);
            }
        }

        if ($product->width > 0
        || $product->height > 0
        || $product->depth > 0
        || $product->weight > 0
        || $cart_weight > 0) {
            foreach ($carrier_list as $key => $id_carrier) {
                $carrier = new Carrier($id_carrier);

                /* Get the sizes of the carrier and the product and sort them to check if the carrier can take
                the product. */
                $carrier_sizes = array(
                    (int) $carrier->max_width,
                    (int) $carrier->max_height,
                    (int) $carrier->max_depth
                );
                $product_sizes = array((int) $product->width, (int) $product->height, (int) $product->depth);
                rsort($carrier_sizes, SORT_NUMERIC);
                rsort($product_sizes, SORT_NUMERIC);

                if (($carrier_sizes[0] > 0 && $carrier_sizes[0] < $product_sizes[0])
                    || ($carrier_sizes[1] > 0 && $carrier_sizes[1] < $product_sizes[1])
                    || ($carrier_sizes[2] > 0 && $carrier_sizes[2] < $product_sizes[2])) {
                    $error[$carrier->id] = Carrier::SHIPPING_SIZE_EXCEPTION;
                    unset($carrier_list[$key]);
                }

                if ($carrier->max_weight > 0
                && ($carrier->max_weight < $product->weight * $cart_quantity || $carrier->max_weight < $cart_weight)) {
                    $error[$carrier->id] = Carrier::SHIPPING_WEIGHT_EXCEPTION;
                    unset($carrier_list[$key]);
                }
            }
        }

        return $carrier_list;
    }

    public function getDeliveryOptionListByIdCountry($idCountry, $idState = false)
    {
        $cart = new Cart((int) $this->context->cart->id);
        $package_list = $this->getPackageListByIdCountry($idCountry, $idState);
        $delivery_option_list = array();
        $carriers_price = array();
        $cache = array();
        $carrier_collection = array();
        foreach ($package_list as $id_address => $packages) {
            // Initialize vars
            $delivery_option_list[$id_address] = array();
            $carriers_price[$id_address] = array();
            $common_carriers = null;
            $best_price_carriers = array();
            $best_grade_carriers = array();
            $carriers_instance = array();

            // Get country
            $country = new Country($idCountry);

            // Foreach packages, get the carriers with best price, best position and best grade
            foreach ($packages as $id_package => $package) {
                // No carriers available
                if (count($packages) == 1
                && count($package['carrier_list']) == 1
                && current($package['carrier_list']) == 0) {
                    $cache[$cart->id] = array();
                    return $cache[$cart->id];
                }

                $carriers_price[$id_address][$id_package] = array();

                // Get all common carriers for each packages to the same address
                if (is_null($common_carriers)) {
                    $common_carriers = $package['carrier_list'];
                } else {
                    $common_carriers = array_intersect($common_carriers, $package['carrier_list']);
                }

                $best_price = null;
                $best_price_carrier = null;
                $best_grade = null;
                $best_grade_carrier = null;

                // Foreach carriers of the package, calculate his price, check if it the best price, position and grade
                foreach ($package['carrier_list'] as $id_carrier) {
                    if (!isset($carriers_instance[$id_carrier])) {
                        $carriers_instance[$id_carrier] = new Carrier($id_carrier);
                    }

                    $price_with_tax = $cart->getPackageShippingCost(
                        (int)$id_carrier,
                        true,
                        $country,
                        $package['product_list']
                    );
                    $price_without_tax = $cart->getPackageShippingCost(
                        (int)$id_carrier,
                        false,
                        $country,
                        $package['product_list']
                    );
                    if (is_null($best_price) || $price_with_tax < $best_price) {
                        $best_price = $price_with_tax;
                        $best_price_carrier = $id_carrier;
                    }
                    $carriers_price[$id_address][$id_package][$id_carrier] = array(
                        'without_tax' => $price_without_tax,
                        'with_tax' => $price_with_tax);

                    $grade = $carriers_instance[$id_carrier]->grade;
                    if (is_null($best_grade) || $grade > $best_grade) {
                        $best_grade = $grade;
                        $best_grade_carrier = $id_carrier;
                    }
                }

                $best_price_carriers[$id_package] = $best_price_carrier;
                $best_grade_carriers[$id_package] = $best_grade_carrier;
            }

            // Reset $best_price_carrier, it's now an array
            $best_price_carrier = array();
            $key = '';

            // Get the delivery option with the lower price
            foreach ($best_price_carriers as $id_package => $id_carrier) {
                $key .= $id_carrier.',';
                if (!isset($best_price_carrier[$id_carrier])) {
                    $best_price_carrier[$id_carrier] = array(
                        'price_with_tax' => 0,
                        'price_without_tax' => 0,
                        'package_list' => array(),
                        'product_list' => array(),
                    );
                }
                $best_price_carrier[$id_carrier]['is_best_price'] = true;
                $best_price_carrier[$id_carrier]['price_with_tax'] +=
                $carriers_price[$id_address][$id_package][$id_carrier]['with_tax'];
                $best_price_carrier[$id_carrier]['price_without_tax'] +=
                $carriers_price[$id_address][$id_package][$id_carrier]['without_tax'];
                $best_price_carrier[$id_carrier]['package_list'][] = $id_package;
                $best_price_carrier[$id_carrier]['product_list'] = array_merge(
                    $best_price_carrier[$id_carrier]['product_list'],
                    $packages[$id_package]['product_list']
                );
                $best_price_carrier[$id_carrier]['instance'] = $carriers_instance[$id_carrier];
                $real_best_price = !isset($real_best_price) || $real_best_price >
                $carriers_price[$id_address][$id_package][$id_carrier]['with_tax'] ?
                $carriers_price[$id_address][$id_package][$id_carrier]['with_tax'] : $real_best_price;
                $real_best_price_wt = !isset($real_best_price_wt) || $real_best_price_wt >
                $carriers_price[$id_address][$id_package][$id_carrier]['without_tax'] ?
                $carriers_price[$id_address][$id_package][$id_carrier]['without_tax'] : $real_best_price_wt;
            }

            // Add the delivery option with best price as best price
            $delivery_option_list[$id_address][$key] = array(
                'carrier_list' => $best_price_carrier,
                'is_best_price' => true,
                'is_best_grade' => false,
                'unique_carrier' => (count($best_price_carrier) <= 1)
            );

            // Reset $best_grade_carrier, it's now an array
            $best_grade_carrier = array();
            $key = '';

            // Get the delivery option with the best grade
            foreach ($best_grade_carriers as $id_package => $id_carrier) {
                $key .= $id_carrier.',';
                if (!isset($best_grade_carrier[$id_carrier])) {
                    $best_grade_carrier[$id_carrier] = array(
                        'price_with_tax' => 0,
                        'price_without_tax' => 0,
                        'package_list' => array(),
                        'product_list' => array(),
                    );
                }
                $best_grade_carrier[$id_carrier]['price_with_tax'] +=
                $carriers_price[$id_address][$id_package][$id_carrier]['with_tax'];
                $best_grade_carrier[$id_carrier]['price_without_tax'] +=
                $carriers_price[$id_address][$id_package][$id_carrier]['without_tax'];
                $best_grade_carrier[$id_carrier]['package_list'][] = $id_package;
                $best_grade_carrier[$id_carrier]['product_list'] = array_merge(
                    $best_grade_carrier[$id_carrier]['product_list'],
                    $packages[$id_package]['product_list']
                );
                $best_grade_carrier[$id_carrier]['instance'] = $carriers_instance[$id_carrier];
            }

            // Add the delivery option with best grade as best grade
            if (!isset($delivery_option_list[$id_address][$key])) {
                $delivery_option_list[$id_address][$key] = array(
                    'carrier_list' => $best_grade_carrier,
                    'is_best_price' => false,
                    'unique_carrier' => (count($best_grade_carrier) <= 1)
                );
            }
            $delivery_option_list[$id_address][$key]['is_best_grade'] = true;

            // Get all delivery options with a unique carrier
            foreach ($common_carriers as $id_carrier) {
                $key = '';
                $package_list = array();
                $product_list = array();
                $price_with_tax = 0;
                $price_without_tax = 0;

                foreach ($packages as $id_package => $package) {
                    $key .= $id_carrier.',';
                    $price_with_tax += $carriers_price[$id_address][$id_package][$id_carrier]['with_tax'];
                    $price_without_tax += $carriers_price[$id_address][$id_package][$id_carrier]['without_tax'];
                    $package_list[] = $id_package;
                    $product_list = array_merge($product_list, $package['product_list']);
                }

                if (!isset($delivery_option_list[$id_address][$key])) {
                    $delivery_option_list[$id_address][$key] = array(
                        'is_best_price' => false,
                        'is_best_grade' => false,
                        'unique_carrier' => true,
                        'carrier_list' => array(
                            $id_carrier => array(
                                'price_with_tax' => $price_with_tax,
                                'price_without_tax' => $price_without_tax,
                                'instance' => $carriers_instance[$id_carrier],
                                'package_list' => $package_list,
                                'product_list' => $product_list,
                            )
                        )
                    );
                } else {
                    $delivery_option_list[$id_address][$key]['unique_carrier'] =
                    (count($delivery_option_list[$id_address][$key]['carrier_list']) <= 1);
                }
            }
        }

        $cart_rules = CartRule::getCustomerCartRules(
            Context::getContext()->cookie->id_lang,
            Context::getContext()->cookie->id_customer,
            true,
            true,
            false,
            $cart,
            true
        );

        $result = false;
        if ($cart->id) {
            $result = Db::getInstance()->executeS(
                'SELECT * FROM '._DB_PREFIX_.'cart_cart_rule WHERE id_cart = '.(int)$cart->id
            );
        }

        $cart_rules_in_cart = array();

        if (is_array($result)) {
            foreach ($result as $row) {
                $cart_rules_in_cart[] = $row['id_cart_rule'];
            }
        }

        $total_products_wt = $cart->getOrderTotal(true, Cart::ONLY_PRODUCTS);
        $total_products = $cart->getOrderTotal(false, Cart::ONLY_PRODUCTS);

        $free_carriers_rules = array();

        $context = Context::getContext();
        foreach ($cart_rules as $cart_rule) {
            $total_price = $cart_rule['minimum_amount_tax'] ? $total_products_wt : $total_products;
            $total_price += $cart_rule['minimum_amount_tax'] && $cart_rule['minimum_amount_shipping'] ?
            $real_best_price : 0;
            $total_price += !$cart_rule['minimum_amount_tax'] && $cart_rule['minimum_amount_shipping'] ?
            $real_best_price_wt : 0;
            if ($cart_rule['free_shipping'] && $cart_rule['carrier_restriction']
                && in_array($cart_rule['id_cart_rule'], $cart_rules_in_cart)
                && $cart_rule['minimum_amount'] <= $total_price) {
                $cr = new CartRule((int)$cart_rule['id_cart_rule']);
                if (Validate::isLoadedObject($cr) &&
                    $cr->checkValidity(
                        $context,
                        in_array((int)$cart_rule['id_cart_rule'], $cart_rules_in_cart),
                        false,
                        false
                    )
                ) {
                    $carriers = $cr->getAssociatedRestrictions('carrier', true, false);
                    if (is_array($carriers) && count($carriers) && isset($carriers['selected'])) {
                        foreach ($carriers['selected'] as $carrier) {
                            if (isset($carrier['id_carrier']) && $carrier['id_carrier']) {
                                $free_carriers_rules[] = (int)$carrier['id_carrier'];
                            }
                        }
                    }
                }
            }
        }

        // For each delivery options :
        //    - Set the carrier list
        //    - Calculate the price
        //    - Calculate the average position
        foreach ($delivery_option_list as $id_address => $delivery_option) {
            foreach ($delivery_option as $key => $value) {
                $total_price_with_tax = 0;
                $total_price_without_tax = 0;
                $position = 0;
                foreach ($value['carrier_list'] as $id_carrier => $data) {
                    $total_price_with_tax += $data['price_with_tax'];
                    $total_price_without_tax += $data['price_without_tax'];
                    $total_price_without_tax_with_rules = (in_array($id_carrier, $free_carriers_rules)) ?
                    0 : $total_price_without_tax;

                    if (!isset($carrier_collection[$id_carrier])) {
                        $carrier_collection[$id_carrier] = new Carrier($id_carrier);
                    }
                    $delivery_option_list[$id_address][$key]['carrier_list'][$id_carrier]['instance'] =
                    $carrier_collection[$id_carrier];

                    if (file_exists(_PS_SHIP_IMG_DIR_.$id_carrier.'.jpg')) {
                        $delivery_option_list[$id_address][$key]['carrier_list'][$id_carrier]['logo'] =
                        _THEME_SHIP_DIR_.$id_carrier.'.jpg';
                    } else {
                        $delivery_option_list[$id_address][$key]['carrier_list'][$id_carrier]['logo'] = false;
                    }

                    $position += $carrier_collection[$id_carrier]->position;
                }
                $delivery_option_list[$id_address][$key]['total_price_with_tax'] = $total_price_with_tax;
                $delivery_option_list[$id_address][$key]['total_price_without_tax'] = $total_price_without_tax;
                $delivery_option_list[$id_address][$key]['is_free'] = !$total_price_without_tax_with_rules ?
                true : false;
                $delivery_option_list[$id_address][$key]['position'] = $position / count($value['carrier_list']);
            }
        }

        // Sort delivery option list
        foreach ($delivery_option_list as &$array) {
            uasort($array, array('Cart', 'sortDeliveryOptionList'));
        }

        return $delivery_option_list;
    }

    public function getDeliveryOptionsByIdCountry($delivery_option_list)
    {
        $objPresenter = new objectPresenter();
        $objPrice = new PriceFormatter();
        $include_taxes = !Product::getTaxCalculationMethod((int) $this->context->cart->id_customer)
        && (int) Configuration::get('PS_TAX');
        $display_taxes_label = (Configuration::get('PS_TAX') && !Configuration::get('AEUC_LABEL_TAX_INC_EXC'));

        $carriers_available = array();

        if (isset($delivery_option_list[$this->context->cart->id_address_delivery])) {
            foreach ($delivery_option_list[$this->context->cart->id_address_delivery] as
            $id_carriers_list => $carriers_list) {
                foreach ($carriers_list as $carriers) {
                    if (is_array($carriers)) {
                        foreach ($carriers as $carrier) {
                            $carrier = array_merge($carrier, $objPresenter->present($carrier['instance']));
                            $delay = $carrier['delay'][$this->context->language->id];
                            unset($carrier['instance'], $carrier['delay']);
                            $carrier['delay'] = $delay;
                            if ($this->isFreeShipping($this->context->cart, $carriers_list)) {
                                $carrier['price'] = $this->module->l('Free', 'wkcheckout');
                            } else {
                                if ($include_taxes) {
                                    $carrier['price'] = $objPrice->format($carriers_list['total_price_with_tax']);
                                    if ($display_taxes_label) {
                                        $carrier['price'] = sprintf(
                                            $this->module->l('%s tax incl.', 'wkcheckout'),
                                            $carrier['price']
                                        );
                                    }
                                } else {
                                    $carrier['price'] = $objPrice->format($carriers_list['total_price_without_tax']);
                                    if ($display_taxes_label) {
                                        $carrier['price'] = sprintf(
                                            $this->module->l('%s tax excl.', 'wkcheckout'),
                                            $carrier['price']
                                        );
                                    }
                                }
                            }

                            if (count($carriers) > 1) {
                                $carrier['label'] = $carrier['price'];
                            } else {
                                $carrier['label'] = $carrier['name'].' - '.$carrier['delay'].' - '.$carrier['price'];
                            }

                            // If carrier related to a module, check for additionnal data to display
                            $carrier['extraContent'] = '';
                            if ($carrier['is_module']) {
                                if ($moduleId = Module::getModuleIdByName($carrier['external_module_name'])) {
                                    $carrier['extraContent'] = Hook::exec(
                                        'displayCarrierExtraContent',
                                        array('carrier' => $carrier),
                                        $moduleId
                                    );
                                }
                            }

                            $carriers_available[$id_carriers_list] = $carrier;
                        }
                    }
                }
            }
        }

        return $carriers_available;
    }

    public function isFreeShipping($cart, array $carrier)
    {
        $free_shipping = false;

        if ($carrier['is_free']) {
            $free_shipping = true;
        } else {
            foreach ($cart->getCartRules() as $rule) {
                if ($rule['free_shipping'] && !$rule['carrier_restriction']) {
                    $free_shipping = true;
                    break;
                }
            }
        }

        return $free_shipping;
    }

    public function sendConfirmationMail(Customer $customer)
    {
        if ($customer->is_guest || !Configuration::get('PS_CUSTOMER_CREATION_EMAIL')) {
            return true;
        }

        return Mail::Send(
            $this->context->language->id,
            'account',
            $this->module->l('Welcome!', 'wkcheckout'),
            array(
                '{firstname}' => $customer->firstname,
                '{lastname}' => $customer->lastname,
                '{email}' => $customer->email,
            ),
            $customer->email,
            $customer->firstname.' '.$customer->lastname
        );
    }
}
