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

class WkOnePageCheckOutWkMyCartModuleFrontController extends ModuleFrontController
{
    public function initContent()
    {
        parent::initContent();
        if ($this->context->customer->id) {
            $priceDisplay = Group::getPriceDisplayMethod(Group::getCurrent()->id);
            if (!$priceDisplay || $priceDisplay == 2) {
                $price_tax = true;
                $this->context->smarty->assign(array('showTax' => 1));
            } elseif ($priceDisplay == 1) {
                $price_tax = false;
            }
            $id = Tools::getValue('id');
            $id_delete = Tools::getValue('id_delete');
            if ($id_delete && $id) {
                $objCart = new WkOnePageCheckOutSaveCart($id);
                if (isset($objCart->id) && $objCart->id) {
                    if ($objCart->delete()) {
                        if((sizeof($objCart->getAllCart($this->context->customer->id)) == 0)
                        && (sizeof($this->context->cart->getProducts())== 0)) {
                            Tools::redirect($this->context->link->getPageLink('index'));
                        } elseif ((sizeof($objCart->getAllCart($this->context->customer->id)) == 0)
                        && (sizeof($this->context->cart->getProducts()) != 0)) {
                            Tools::redirect($this->context->link->getPageLink('order'));
                        } else {
                            Tools::redirect(
                                $this->context->link->getModuleLink(
                                    $this->module->name,
                                    'wkmycart',
                                    array('success' => 1)
                                )
                            );
                        }
                    } else {
                        Tools::redirect($this->context->link->getModuleLink($this->module->name, 'wkmycart'));
                    }
                }
            }
            $savedCart = WkOnePageCheckOutSaveCart::getAllCart($this->context->customer->id);
            if ($savedCart) {
                foreach ($savedCart as $key => $cart) {
                    $product = new Product($cart['id_product'], null, $this->context->language->id);
                    $attribute = $product->getAttributesResume($this->context->language->id);
                    if ($attribute) {
                        foreach ($attribute as $attr) {
                            if ($attr['id_product_attribute'] == $cart['id_product_attribute']) {
                                $savedCart[$key]['attribute_name'] = $attr['attribute_designation'];
                            }
                        }
                    }
                    $savedCart[$key]['available_qty'] = Product::getQuantity(
                        $cart['id_product'],
                        $cart['id_product_attribute']
                    );
                    if ($savedCart[$key]['available_qty']) {
                        $savedCart[$key]['available_for_order'] = 1;
                    } else {
                        $savedCart[$key]['available_for_order'] = Product::isAvailableWhenOutOfStock(
                            StockAvailable::outOfStock($cart['id_product'])
                        );
                    }
                    $savedCart[$key]['product_name'] = $product->name;
                    if ($cart['id_product_attribute']) {
                        $product_price = Product::getPriceStatic(
                            $cart['id_product'],
                            $price_tax,
                            $cart['id_product_attribute']
                        );
                    } else {
                        $product_price = Product::getPriceStatic($cart['id_product'], $price_tax);
                    }
                    $product_price =  Tools::displayPrice($product_price, Context::getContext()->currency);
                    $savedCart[$key]['product_price'] = $product_price;

                    $product_link = $this->context->link->getProductLink(
                        $product,
                        $product->link_rewrite,
                        Category::getLinkRewrite($product->id_category_default, $this->context->language->id),
                        null,
                        null,
                        null,
                        $cart['id_product_attribute']
                    );
                    $savedCart[$key]['product_link'] = $product_link;
                    unset($product);
                }
                $this->context->smarty->assign(array(
                    'savedCart' => $savedCart,
                    'modules_dir' => _MODULE_DIR_,
                    'wksavecart' => $this->context->link->getModuleLink(
                        $this->module->name,
                        'wkmycart',
                        array('id_delete' => 1)
                    ),
                ));
                Media::addJsDef(array(
                    'wkmycart' => $this->context->link->getModuleLink('wkonepagecheckout', 'wkmycart'),
                    'wkorder' => $this->context->link->getPageLink('order'),
                    'wktoken' => Tools::getToken(false)
                ));
            }
            $this->setTemplate('module:wkonepagecheckout/views/templates/front/wkmycart.tpl');
        } else {
            Tools::redirect($this->context->link->getPageLink('my-account'));
        }
    }

    public function setMedia()
    {
        parent::setMedia();
        Media::addJsDef(
            array(
                'wkNoLongerMsg' => $this->module->l('This product is no longer available', 'wkmycart'),
                'wkOutofStockMsg' => $this->module->l('There are not enough products in stock', 'wkmycart'),
                'wkAddMsg' => $this->module->l('You must add more quantity', 'wkmycart'),
                'wkMaxMsg' => $this->module->l('You exceed maximum quantity for this product', 'wkmycart')
            )
        );
        $this->context->controller->addJqueryPlugin('growl', null, false);
        $this->context->controller->registerStylesheet('growl-css', 'js/jquery/plugins/growl/jquery.growl.css');
        $this->registerJavascript(
            'wkonepagecheckout-cartsave',
            'modules/wkonepagecheckout/views/js/wkcartsave.js'
        );
    }

    public function displayAjaxProcessChangeProductInCart()
    {
        $idProduct = Tools::getValue('id_product');
        $idProductAttribute = Tools::getValue('idProductAttribute');
        $qty = Tools::getValue('qty');

        $availableQty = Product::getQuantity($idProduct, $idProductAttribute);
        if ($qty > $availableQty) {
            $qty = $availableQty;
        }

        $product = new Product($idProduct, true, $this->context->language->id);
        if (!$product->id || !$product->active || !$product->checkAccess($this->context->cart->id_customer)) {
            die('0'); //'This product is no longer available.'
        }

        $qty_to_check = $qty;
        $cart_products = $this->context->cart->getProducts();

        if (is_array($cart_products)) {
            foreach ($cart_products as $cart_product) {
                if ($this->productInCartMatchesCriteria($cart_product, $idProduct, $idProductAttribute)) {
                    $qty_to_check = $cart_product['cart_quantity'];
                    $qty_to_check += $qty;
                    break;
                }
            }
        }

        // Check product quantity availability
        if ($idProductAttribute) {
            if (!Product::isAvailableWhenOutOfStock($product->out_of_stock)
            && !Attribute::checkAttributeQty($idProductAttribute, $qty_to_check)) {
                die('2'); //There are not enough products in stock'
            }
        } elseif ($product->hasAttributes()) {
            $minimumQuantity = ($product->out_of_stock == 2) ?
            !Configuration::get('PS_ORDER_OUT_OF_STOCK') : !$product->out_of_stock;
            $idProductAttribute = Product::getDefaultAttribute($product->id, $minimumQuantity);
            // @todo do something better than a redirect admin !!
            if (!$idProductAttribute) {
                Tools::redirectAdmin($this->context->link->getProductLink($product));
            } elseif (!Product::isAvailableWhenOutOfStock($product->out_of_stock)
            && !Attribute::checkAttributeQty($idProductAttribute, $qty_to_check)) {
                die('2');   //There are not enough products in stock'
            }
        } elseif (!$product->checkQty($qty_to_check)) {
            die('2');   //There are not enough products in stock'
        }

        // If no errors, process product addition
        if (!$this->errors) {
            // Add cart if no cart found
            if (!$this->context->cart->id) {
                if (Context::getContext()->cookie->id_guest) {
                    $guest = new Guest(Context::getContext()->cookie->id_guest);
                    $this->context->cart->mobile_theme = $guest->mobile_theme;
                }
                $this->context->cart->add();
                if ($this->context->cart->id) {
                    $this->context->cookie->id_cart = (int)$this->context->cart->id;
                }
            }

            if (!$this->errors) {
                $update_quantity = $this->context->cart->updateQty(
                    $qty,
                    $idProduct,
                    $idProductAttribute,
                    null,
                    'up',
                    $this->context->cart->id_address_delivery
                );
                if ($update_quantity < 0) {
                    //You must add %d minimum quantity', array($minimal_quantity)
                    die('3');
                } elseif (!$update_quantity) {
                    //You already have the maximum quantity available for this product.''Shop.Notifications.Error');
                    die('4');
                }
            }
        }

        CartRule::autoRemoveFromCart();
        CartRule::autoAddToCart();
        WkOnePageCheckOutSaveCart::removeSavedCart($this->context->customer->id, $idProduct, $idProductAttribute);
        die('1');
    }

    public function productInCartMatchesCriteria($productInCart, $idProduct, $idProductAttribute)
    {
        return (!isset($idProductAttribute)
        || ($productInCart['id_product_attribute'] == $idProductAttribute))
        && isset($idProduct)
        && $productInCart['id_product'] == $idProduct;
    }
}
