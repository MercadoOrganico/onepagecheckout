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

use PrestaShop\PrestaShop\Core\Module\WidgetInterface;
use PrestaShop\PrestaShop\Adapter\Image\ImageRetriever;
use PrestaShop\PrestaShop\Adapter\Product\PriceFormatter;
use PrestaShop\PrestaShop\Core\Product\ProductListingPresenter;
use PrestaShop\PrestaShop\Adapter\Product\ProductColorsRetriever;

class WkOnePageCheckoutHelper extends ObjectModel
{
    public static function getModuleIdByName($hook_name)
    {
        $hook_name = Tools::strtolower($hook_name);
        if (!Validate::isHookName($hook_name)) {
            return false;
        }

        return Db::getInstance()->getValue(
            'SELECT `id_module` FROM `'._DB_PREFIX_.'module` WHERE `name` = \''.pSQL($hook_name).'\''
        );
    }

    public static function checkCountryRestrictionByIdModule($idModule, $idCountry)
    {
        return Db::getInstance()->getValue(
            'SELECT `id_module` FROM `'._DB_PREFIX_.'module_country`
            WHERE `id_module` = '.(int) $idModule.'
            AND `id_country` = '.(int) $idCountry
        );
    }

    public static function checkCarrierRestrictionByIdModule($idModule, $idCarrier)
    {
        return Db::getInstance()->getValue(
            'SELECT `id_module` FROM `'._DB_PREFIX_.'module_carrier`
            WHERE `id_module` = '.(int) $idModule.'
            AND `id_reference` = '.(int) $idCarrier
        );
    }

    public static function getOrderProducts(array $productIds = array())
    {
        $context = Context::getContext();
        $q_orders = 'SELECT o.`id_order` FROM '._DB_PREFIX_.'orders o
            LEFT JOIN '._DB_PREFIX_.'order_detail od ON (od.id_order = o.id_order) WHERE o.valid = 1
            AND od.product_id IN ('.implode(',', $productIds).')';
        $orders = Db::getInstance(_PS_USE_SQL_SLAVE_)->executeS($q_orders);
        if (0 < count($orders)) {
            $list = '';
            foreach ($orders as $order) {
                $list .= (int)$order['id_order'].',';
            }
            $list = rtrim($list, ',');
            $list_product_ids = join(',', $productIds);

            if (Group::isFeatureActive()) {
                $sql_groups_join = '
                LEFT JOIN `'._DB_PREFIX_.'category_product` cp
                ON (cp.`id_category` = product_shop.id_category_default AND cp.id_product = product_shop.id_product)
                LEFT JOIN `'._DB_PREFIX_.'category_group` cg ON (cp.`id_category` = cg.`id_category`)';
                $groups = FrontController::getCurrentCustomerGroups();
                $sql_groups_where = 'AND cg.`id_group` '. (count($groups) ? '
                IN ('.implode(',', $groups) . ')' : '=' . (int)Group::getCurrent()->id);
            }

            $order_products = Db::getInstance(_PS_USE_SQL_SLAVE_)->executeS(
                'SELECT DISTINCT od.product_id
                FROM '._DB_PREFIX_.'order_detail od
                LEFT JOIN '._DB_PREFIX_.'product p ON (p.id_product = od.product_id)
                '.Shop::addSqlAssociation('product', 'p').
                (
                    Combination::isFeatureActive() ? 'LEFT JOIN `'._DB_PREFIX_.'product_attribute` pa
                    ON (p.`id_product` = pa.`id_product`)
                    ' . Shop::addSqlAssociation(
                        'product_attribute',
                        'pa',
                        false,
                        'product_attribute_shop.`default_on` = 1'
                    ).'
                    ' . Product::sqlStock(
                        'p',
                        'product_attribute_shop',
                        false,
                        $context->shop
                    ) :  Product::sqlStock(
                        'p',
                        'product',
                        false,
                        $context->shop
                    )
                ).'
                LEFT JOIN '._DB_PREFIX_.'product_lang pl ON (pl.id_product = od.product_id' .
                Shop::addSqlRestrictionOnLang('pl').')
                LEFT JOIN '._DB_PREFIX_.'category_lang cl ON (cl.id_category = product_shop.id_category_default'
                .Shop::addSqlRestrictionOnLang('cl').')
                LEFT JOIN '._DB_PREFIX_.'image i ON (i.id_product = od.product_id)
                '.(Group::isFeatureActive() ? $sql_groups_join : '').'
                WHERE od.id_order IN (\''.pSQL($list).'\')
                AND pl.id_lang = '.(int) $context->language->id.'
                AND cl.id_lang = '.(int) $context->language->id.'
                AND od.product_id NOT IN (\''.pSQL($list_product_ids).'\')
                AND i.cover = 1
                AND product_shop.active = 1
                '.(Group::isFeatureActive() ? $sql_groups_where : '').'
                ORDER BY RAND()
                LIMIT '.(int) Configuration::get('WK_CHECKOUT_ALSO_BOUGHT_NUMBER')
            );
        }

        if (!empty($order_products)) {
            $assembler = new ProductAssembler($context);

            $presenterFactory = new ProductPresenterFactory($context);
            $presentationSettings = $presenterFactory->getPresentationSettings();
            $presenter = new ProductListingPresenter(
                new ImageRetriever(
                    $context->link
                ),
                $context->link,
                new PriceFormatter(),
                new ProductColorsRetriever(),
                $context->getTranslator()
            );

            $productsForTemplate = array();

            $presentationSettings->showPrices = true;
            if (is_array($order_products)) {
                foreach ($order_products as $productId) {
                    $productsForTemplate[] = $presenter->present(
                        $presentationSettings,
                        $assembler->assembleProduct(array('id_product' => $productId['product_id'])),
                        $context->language
                    );
                }
            }
            return $productsForTemplate;
        }

        return false;
    }
}
