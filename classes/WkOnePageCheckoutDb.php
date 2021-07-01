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

class WkOnePageCheckoutDb
{
    public function createTables()
    {
        if ($sql = $this->getModuleSql()) {
            foreach ($sql as $query) {
                if ($query) {
                    if (!Db::getInstance()->execute(trim($query))) {
                        return false;
                    }
                }
            }
        }
        return true;
    }

    public function getModuleSql()
    {
        return array(
            "CREATE TABLE IF NOT EXISTS `"._DB_PREFIX_."wk_checkout_save_later` (
                `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
                `id_product` int(11) unsigned NOT NULL DEFAULT 0,
                `id_product_attribute` int(11) unsigned NOT NULL DEFAULT 0,
                `id_cart` int(11) unsigned NOT NULL,
                `quantity` int(11) unsigned NOT NULL DEFAULT 0,
                `id_customer` int(11) unsigned NOT NULL,
                `date_add` datetime NOT NULL,
                `date_upd` datetime NOT NULL,
                PRIMARY KEY (`id`)
            ) ENGINE="._MYSQL_ENGINE_." DEFAULT CHARSET=utf8"
        );
    }

    /**
     * Delete module tables
     *
     * @return bool
     */
    public function deleteTables()
    {
        return Db::getInstance()->execute('
            DROP TABLE IF EXISTS
            `'._DB_PREFIX_.'wk_checkout_save_later`;
        ');
    }
}
