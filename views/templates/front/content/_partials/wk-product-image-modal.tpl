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

<div id="product-modal">
    <div class="modal fade js-product-images-modal" id="wk-product-modal-{$product.id_product}">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-body">
                    <button type="button" class="close product-image-modal-close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                    {assign var=imagesCount value=$product.images|count}
                    <figure>
                        <img class="js-modal-product-cover-{$product.id_product} product-cover-modal" width="{$product.cover.large.width}" src="{$product.cover.large.url}" alt="{$product.cover.legend}" title="{$product.cover.legend}" itemprop="image">
                        <figcaption class="image-caption">
                            {block name='product_description_short'}
                                <div id="product-description-short" itemprop="description">{$product.description_short nofilter}</div>
                            {/block}
                        </figcaption>
                    </figure>
                    <aside id="thumbnails" class="thumbnails js-thumbnails text-xs-center">
                        {block name='product_images'}
                        <div class="js-modal-mask mask {if $imagesCount <= 5} nomargin {/if}">
                            <ul class="product-images js-modal-product-images">
                                {foreach from=$product.images item=image}
                                    <li class="thumb-container">
                                        <img data-id-product="{$product.id_product}" data-image-large-src="{$image.large.url}" class="thumb js-modal-thumb" src="{$image.medium.url}" alt="{$image.legend}" title="{$image.legend}" width="{$image.medium.width}" itemprop="image">
                                    </li>
                                {/foreach}
                            </ul>
                        </div>
                        {/block}
                        {if $imagesCount > 5}
                            <div class="arrows js-modal-arrows">
                                <i class="material-icons arrow-up js-modal-arrow-up">&#xE5C7;</i>
                                <i class="material-icons arrow-down js-modal-arrow-down">&#xE5C5;</i>
                            </div>
                        {/if}
                    </aside>
                </div>
            </div>
        </div>
    </div>
</div>
