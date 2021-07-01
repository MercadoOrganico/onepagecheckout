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

class WkOnePageCheckOutSaveCart extends ObjectModel
{
    public $id_product;
    public $id_product_attribute;
    public $id_cart;
    public $quantity;
    public $id_customer;
    public $date_add;
    public $date_upd;

    public static $definition = array(
        'table' => 'wk_checkout_save_later',
        'primary' => 'id',
        'fields' => array(
            'id_product' => array('type' => self::TYPE_INT, 'required' => true),
            'id_product_attribute' => array('type' => self::TYPE_INT, 'required' => true),
            'id_cart' => array('type' => self::TYPE_INT, 'required' => true),
            'quantity' => array('type' => self::TYPE_INT, 'required' => true),
            'id_customer' => array('type' => self::TYPE_INT,'required' => true),
            'date_add' => array('type' => self::TYPE_DATE, 'validate' => 'isDateFormat', 'required' => false),
            'date_upd' => array('type' => self::TYPE_DATE, 'validate' => 'isDateFormat', 'required' => false),
            ),
        );

    public static function isExist($idProduct, $idProductAttribute, $idCart)
    {
        return Db::getInstance()->getValue(
            'SELECT `id` FROM `'._DB_PREFIX_.'wk_checkout_save_later` WHERE
                `id_product` = '.(int) $idProduct.' AND
                `id_product_attribute` = '.(int) $idProductAttribute.' AND
                `id_cart` = '.(int) $idCart
        );
    }

    public static function getAllCart($idCustomer)
    {
        return Db::getInstance()->executeS(
            'SELECT * FROM '._DB_PREFIX_.'wk_checkout_save_later WHERE `id_customer` = '.(int) $idCustomer
        );
    }

    public static function removeSavedCart($idCustomer, $idProduct, $idProductAttribute)
    {
        return Db::getInstance()->delete(
            'wk_checkout_save_later',
            'id_product = '.(int) $idProduct.' AND
            `id_product_attribute` ='.(int) $idProductAttribute.' AND
            `id_customer` = '.(int) $idCustomer
        );
    }

    public function deleteSavedCartByIdProduct($idProduct)
    {
        return Db::getInstance()->delete(
            'wk_checkout_save_later',
            'id_product = '.(int) $idProduct
        );
    }

    public function deleteSavedCartByIdCustomer($idCustomer)
    {
        return Db::getInstance()->delete(
            'wk_checkout_save_later',
            '`id_customer` = '.(int) $idCustomer
        );
    }
}
