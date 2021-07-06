import 'package:flutter_html/style.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../ui/products/products/products_scroll2.dart';
import '../../../ui/products/products/product_grid.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import '../../../../assets/presentation/m_store_icons_icons.dart';
import '../../../chat/pages/chat_page.dart';
import '../../../ui/products/product_grid/products_widgets/product_addons.dart';
import '../../color_override.dart';
import '../reviews/reviewDetail.dart';
import '../reviews/write_review.dart';
import '../reviews/review_list.dart';
import '../../../ui/checkout/cart/cart4.dart';
import '../../../functions.dart';
import './../product_grid/products_widgets/add_button_detail.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_icons/flutter_icons.dart';
import '../../../blocs/vendor/vendor_detail_state_model.dart';
import '../../vendor/ui/products/vendor_detail/vendor_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:share/share.dart';
import '../../../models/app_state_model.dart';
import '../../accounts/login/login.dart';
import '../../../models/releated_products.dart';
import '../../../models/review_model.dart';
import '../../../blocs/product_detail_bloc.dart';
import '../../../models/product_model.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'gallery_view.dart';

class ProductDetail2 extends StatefulWidget {
  final ProductDetailBloc productDetailBloc = ProductDetailBloc();
  final Product product;
  final appStateModel = AppStateModel();
  ProductDetail2({Key key, this.product}) : super(key: key);
  @override
  _ProductDetail2State createState() => _ProductDetail2State();
}

class _ProductDetail2State extends State<ProductDetail2> {

  bool addingToCart = false;
  bool buyingNow = false;
  int _quantity = 1;
  Map<String, dynamic> addOnsFormData = Map<String, dynamic>();
  final addonFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    widget.productDetailBloc.getProduct(widget.product);
    widget.productDetailBloc.getProductsDetails(widget.product.id);
    widget.productDetailBloc.getReviews(widget.product.id);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Product>(
        stream: widget.productDetailBloc.product,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              floatingActionButton: ScopedModelDescendant<AppStateModel>(
                  builder: (context, child, model) {
                    if (model.blocks?.settings?.enableProductChat == 1) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 50.0),
                        child: FloatingActionButton(
                          onPressed: () async {
                            final url = snapshot.data.vendor.phone != null
                                ? 'https://wa.me/' +
                                snapshot.data.vendor.phone.toString()
                                : 'https://wa.me/' +
                                model.blocks.settings.whatsappNumber.toString();
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          tooltip: 'Chat',
                          child: Icon(Icons.chat_bubble),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }),
              body: Builder(
                  builder: (context) {
                    if (widget.appStateModel.blocks.settings
                        .footerAddToCartButton) {
                      return Stack(
                        children: [
                          CustomScrollView(
                            slivers: _buildSlivers(context, snapshot.data),
                          ),
                          Positioned(
                            bottom: 0,
                            child: _qSelector(snapshot.data),
                          ),
                        ],
                      );
                    } else {
                      return CustomScrollView(
                        slivers: _buildSlivers(context, snapshot.data),
                      );
                    }
                  }
              ),
            );
          } else {
            return Scaffold(appBar: AppBar(), body: Center(child: CircularProgressIndicator()));
          }
        });
  }

  _buildSlivers(BuildContext context, Product product) {
    List<Widget> list = new List<Widget>();

    list.add(_buildAppBar(product));

    list.add(_buildImageGallery(product));

    list.add(_productName(product));

    list.add(_productPriceRating(product));

    if(product.vendor?.name != null &&
        product.vendor?.icon != null) list.add(buildStore(product));

    if (product.availableVariations != null &&
        product.availableVariations?.length != 0) {
      for (var i = 0; i < product.variationOptions.length; i++) {
        if (product.variationOptions[i].options.length != 0) {
          list.add(buildOptionHeader(product.variationOptions[i].name));
          list.add(buildProductVariations(product.variationOptions[i], product));
        }
      }
    }

    list.add(ProductAddons(
        product: product,
        addOnsFormData: addOnsFormData,
        addonFormKey: addonFormKey));

    //list.add(_buildQuantityInput());

    if(!widget.appStateModel.blocks.settings.footerAddToCartButton)
      list.add(_buildAddToCart(context, product));

    //list.add(_buildAddToCartAndBuyNow(context, product));

    list.add(_productDescription(product));

    list.add(_productShortDescription(product));

    list.add(_productAttributes(product));

    list.add(buildLisOfReleatedProducts(product));
    list.add(buildLisOfCrossSellProducts(product));
    list.add(buildLisOfUpSellProducts(product));
    list.add(buildWriteYourReview(product));
    list.add(ReviewList(productDetailBloc: widget.productDetailBloc));

    list.add(SliverToBoxAdapter(
      child: Container(
        height: 60,
      ),
    ));

    return list;
  }

  Widget _buildImageGallery(Product product) {
    return SliverToBoxAdapter(
      child: Container(
        height: MediaQuery.of(context).size.width,
        child: Swiper(
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              splashColor: Theme.of(context).hintColor,
              onTap: () => null,
              child: CachedNetworkImage(
                imageUrl: product.images[index].src,
                imageBuilder: (context, imageProvider) => Ink.image(
                  child: InkWell(
                    splashColor: Theme.of(context).hintColor,
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return GalleryView(
                                images: product.images);
                          }));
                    },
                  ),
                  image: imageProvider,
                  fit: BoxFit.fill,
                ),
                placeholder: (context, url) => Container(color: Colors.white),
                errorWidget: (context, url, error) =>
                    Container(color: Colors.white),
              ),
            );
          },
          itemCount: product.images.length,
          pagination: new SwiperPagination(),
          autoplay: true,
        ),
      ),
    );
  }

  Widget _productName(Product product) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Text(product.name, style: Theme.of(context).textTheme.bodyText1),
      ),
    );
  }

  Widget _productPriceRating(Product product) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: product.formattedSalesPrice != null ? Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(parseHtmlString(product.formattedSalesPrice), maxLines: 1, style: Theme.of(context).textTheme.headline6.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w800,
            )),
            SizedBox(width: 4),
            Text(parseHtmlString(product.formattedPrice), maxLines: 1, style: Theme.of(context).textTheme.caption.copyWith(
              decoration: TextDecoration.lineThrough,
              decorationColor: Theme.of(context).hintColor.withOpacity(0.8),
              decorationThickness: 1,
            )),
          ],
        ) : Text(parseHtmlString(product.formattedPrice), maxLines: 1, style: Theme.of(context).textTheme.headline6.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w800,
        )),
      ),
    );
  }

  Widget _productDescription(Product product) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.fromLTRB(12, 4, 12, 4),
        child: Html(
          data: product.description,
          style: _buildStyle(),
        ),
      ),
    );
  }

  Widget _productShortDescription(Product product) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.fromLTRB(12, 4, 12, 4),
        child: Html(
          data: product.shortDescription,
          style: _buildStyle(),
        ),
      ),
    );
  }

  _buildStyle() {
    return {
      "*": Style(textAlign: TextAlign.justify),
      "p": Style(color: Theme.of(context).hintColor),
    };
  }

  Widget _buildAddToCart(BuildContext context, Product product) {
    return SliverList(
        delegate: SliverChildListDelegate([
          Container(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8.0),
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: product.stockStatus != 'outofstock'
                          ? () {
                        addToCart(context, product);
                      } : null,
                      child: product.stockStatus == 'outofstock' ? Text(widget.appStateModel.blocks.localeText.outOfStock,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1.copyWith(
                              color: Theme.of(context)
                                  .errorColor)) : addingToCart ? Container(
                          width: 17,
                          height: 17,
                          child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).buttonTheme.colorScheme.onPrimary),
                              strokeWidth: 2.0)) : Text(widget.appStateModel.blocks.localeText.
                      addToCart),
                    ),
                  ])),
        ]));
  }

  Widget _buildAddToCartAndBuyNow(BuildContext context, Product product) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: RaisedButton(
                onPressed: () {
                  addToCart(context, product);
                },
                child: addingToCart ? Container(
                    width: 17,
                    height: 17,
                    child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            Theme.of(context).buttonTheme.colorScheme.onPrimary),
                        strokeWidth: 2.0)) : Text(widget.appStateModel.blocks.localeText.
                addToCart),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: RaisedButton(
                color: Theme.of(context).accentColor,
                onPressed: () {
                  buyNow(context, product);
                },
                child: buyingNow ? Container(
                    width: 17,
                    height: 17,
                    child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            Theme.of(context).buttonTheme.colorScheme.onPrimary),
                        strokeWidth: 2.0)) : Text(widget.appStateModel.blocks.localeText.
                buyNow),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOptionHeader(String name) {
    return SliverToBoxAdapter(
      child: Container(
          padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
          child: Text(
            name,
            style: Theme.of(context).textTheme.subtitle2,
          )),
    );
  }

  buildProductVariations(VariationOption variationOption, Product product) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
        child: Wrap(
          spacing: 6.0,
          runSpacing: 6.0,
          children: List<Widget>.generate(variationOption.options.length, (int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  variationOption.selected = variationOption.options[index];
                  product.stockStatus = 'instock';
                });
                if (product.variationOptions
                    .every((option) => option.selected != null)) {
                  var selectedOptions = new List<String>();
                  var matchedOptions = new List<String>();
                  for (var i = 0;
                  i < product.variationOptions.length;
                  i++) {
                    selectedOptions
                        .add(product.variationOptions[i].selected);
                  }
                  for (var i = 0;
                  i < product.availableVariations.length;
                  i++) {
                    matchedOptions = new List<String>();
                    for (var j = 0;
                    j < product.availableVariations[i].option.length;
                    j++) {
                      if (selectedOptions.contains(product
                          .availableVariations[i].option[j].value) ||
                          product.availableVariations[i].option[j].value
                              .isEmpty) {
                        matchedOptions.add(product.availableVariations[i].option[j].value);
                      }
                    }
                    if (matchedOptions.length == selectedOptions.length) {
                      setState(() {
                        product.variationId = product.availableVariations[i].variationId
                            .toString();
                        if(product.availableVariations[i].displayPrice != null)
                          product.regularPrice = product.availableVariations[i].displayPrice
                              .toDouble();
                        product.formattedPrice = product.availableVariations[i].formattedPrice;
                        if(product.availableVariations[i].formattedSalesPrice != null)
                          product.formattedSalesPrice = product.availableVariations[i].formattedSalesPrice;

                        if(product.availableVariations[i].image?.fullSrc != null && product
                            .availableVariations[i].image.fullSrc.isNotEmpty)
                          product.images[0].src = product
                              .availableVariations[i].image.fullSrc;

                        if (product.availableVariations[i]
                            .displayRegularPrice !=
                            product.availableVariations[i].displayPrice) {
                          product.salePrice = product
                              .availableVariations[i].displayRegularPrice
                              .toDouble();
                        }
                        else
                          product.formattedSalesPrice = null;
                      });
                      if (!product.availableVariations[i].isInStock) {
                        setState(() {
                          product.stockStatus = 'outofstock';
                        });
                      }
                      break;
                    }
                  }
                  if (matchedOptions.length != selectedOptions.length) {
                    setState(() {
                      product.stockStatus = 'outofstock';
                    });
                  }
                }
              },
              child: Chip(
                shape: StadiumBorder(),
                backgroundColor: variationOption.selected ==
                    variationOption.options[index] ? Theme.of(context).accentColor : Colors.black12,
                label: Text(
                  variationOption.options[index].toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10.0,
                    color: variationOption.selected ==
                        variationOption.options[index]
                        ? Theme.of(context).accentTextTheme.bodyText1.color
                        : Theme.of(context).textTheme.bodyText1.color,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget buildLisOfReleatedProducts(Product product) {
    String title =
    widget.appStateModel.blocks.localeText.relatedProducts.toUpperCase();
    return StreamBuilder<ReleatedProductsModel>(
        stream: widget.productDetailBloc.relatedProducts,
        builder: (context, AsyncSnapshot<ReleatedProductsModel> snapshot) {
          if (snapshot.hasData) {
            return buildProductList(
                snapshot.data.relatedProducts, context, title);
          } else {
            return SliverToBoxAdapter();
          }
        });
  }

  Widget buildLisOfCrossSellProducts(Product product) {
    String title =
    widget.appStateModel.blocks.localeText.justForYou.toUpperCase();
    return StreamBuilder<ReleatedProductsModel>(
        stream: widget.productDetailBloc.relatedProducts,
        builder: (context, AsyncSnapshot<ReleatedProductsModel> snapshot) {
          if (snapshot.hasData) {
            return buildProductList(
                snapshot.data.crossProducts, context, title);
          } else {
            return SliverToBoxAdapter();
          }
        });
  }

  Widget buildLisOfUpSellProducts(Product product) {
    String title =
    widget.appStateModel.blocks.localeText.youMayAlsoLike.toUpperCase();
    return StreamBuilder<ReleatedProductsModel>(
        stream: widget.productDetailBloc.relatedProducts,
        builder: (context, AsyncSnapshot<ReleatedProductsModel> snapshot) {
          if (snapshot.hasData) {
            return buildProductList(
                snapshot.data.upsellProducts, context, title);
          } else {
            return SliverToBoxAdapter();
          }
        });
  }

  Widget buildProductList(
      List<Product> products, BuildContext context, String title) {
    if (products.length > 0) {
      return ProductScroll(products: products, context: context, title: title);
    } else {
      return Container(
        child: SliverToBoxAdapter(),
      );
    }
  }

  Widget buildWriteYourReview(Product product) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          [
            StreamBuilder<List<ReviewModel>>(
                stream: widget.productDetailBloc.allReviews,
                builder: (context, AsyncSnapshot<List<ReviewModel>> snapshot) {
                  if (snapshot.hasData && snapshot.data.length > 0) {
                    return InkWell(
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReviewsDetail(product: product, productDetailBloc: widget.productDetailBloc)));
                      },
                      child: Column(
                        children: [
                          ListTile(
                            trailing: Icon(Icons.keyboard_arrow_right),
                            title: Text(widget.appStateModel.blocks.localeText.reviews + '(' + snapshot.data.length.toString() +')'
                              ,
                              style: Theme.of(context).textTheme.headline6.copyWith(
                                  fontWeight: FontWeight.w700
                              ),),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 0),
                            child: Row(

                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: product.averageRating.toString(),
                                    style: Theme.of(context).textTheme.headline5.copyWith(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(text: '/5', style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.grey),),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                SmoothStarRating(
                                  color: Colors.amber,
                                  borderColor: Colors.amber,
                                  isReadOnly: true,
                                  size: 20 ,
                                  rating: double.parse(product.averageRating),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  } else {
                    return Container();
                  }
                }),

            Container(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ReviewsPage(productId: product.id)));
                },
                child: ListTile(
                  trailing: Icon(Icons.keyboard_arrow_right),
                  title: Text(widget.appStateModel.blocks.localeText.writeYourReview),
                ),
              ),
            ),
            Divider(
              thickness: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStore(Product product) {
    return SliverToBoxAdapter(
        child: buildStoreTile(context, product.vendor));
  }

  buildStoreTile(BuildContext context, Vendor store) {
    return InkWell(
      /*onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  VendorDetails(vendorId: store.id.toString()))),*/
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 16.0, 16.0, 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(
                  radius: 20.0,
                  backgroundImage: NetworkImage(store.icon),
                ),
                SizedBox(
                  width: 16.0,
                ),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(store.name,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400)),
                          ],
                        ),
                      ]),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            //  Text(store.email),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(Product product) {
    return SliverAppBar(
        floating: false,
        pinned: true,
        snap: false,
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.share,
                semanticLabel: 'Share',
              ),
              onPressed: () {
                Share.share(product.permalink);
              }),
          ScopedModelDescendant<AppStateModel>(
              builder: (context, child, model) {
                return IconButton(
                  onPressed: () {
                    if (!model.loggedIn) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Login()));
                    } else {
                      model.updateWishList(product.id);
                    }
                  },
                  icon: model.wishListIds
                      .contains(product.id)
                      ? Icon(
                    Icons.favorite,
                  )
                      : Icon(
                    Icons.favorite_border,
                  ),
                );
              }),
          CartIcon(context: context),
        ]
    );
  }

  Widget _qSelector(Product product) {
    return Container(
        width: MediaQuery.of(context).size.width,
        color: Theme.of(context).canvasColor,
        height: 55,
        child: Row(
          children: <Widget>[
            widget.appStateModel.blocks.settings.isMultivendor ? Container(
              height: MediaQuery.of(context).size.height,
              width: 120,
              child: Row(
                children: <Widget>[
                  Container(
                    width: 58,
                    child: InkWell(
                      onTap: () {
                        print(product.vendor.id);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VendorDetails(vendorId: product.vendor.id)));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            // height:30,
                            alignment: Alignment.topCenter,
                            child: Icon(
                              MStoreIcons.store_2_line,
                              color: Theme.of(context).brightness == Brightness.light ? Theme.of(context).accentColor : Colors.white,
                              semanticLabel: 'Store',size: 20,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(widget.appStateModel.blocks.localeText.stores,style: TextStyle(
                              color: Theme.of(context).textTheme.bodyText1.color,
                              fontSize: 12
                          ),)
                        ],
                      ),
                    ),
                  ),
                  Container(
                      height: 55,
                      width: 4,
                      child:VerticalDivider(
                        color: Colors.grey,
                      )
                  ),
                  Container(
                    width: 58,
                    child: InkWell(
                      onTap: () {
                        _chatWithVendor(product);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            //height:30,
                            alignment: Alignment.topCenter,
                            child: Icon(
                              Icons.chat_bubble_outline,
                              color: Theme.of(context).brightness == Brightness.light ? Theme.of(context).accentColor : Colors.white,
                              semanticLabel: 'Contact',size: 20,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(widget.appStateModel.blocks.localeText.contacts,style: TextStyle(
                              color: Theme.of(context).textTheme.bodyText1.color,
                              fontSize: 12
                          ),)
                        ],
                      ),
                    ),
                  )                ],
              ),
            ) : Container(),
            ScopedModelDescendant<AppStateModel>(builder: (context, child, model) {
              return Expanded(
                child: Container(
                  height: 55,
                  child: AddButtonDetail(
                    product: product,
                    model: model,
                    addonFormKey: addonFormKey,
                    addOnsFormData: addOnsFormData,),
                ),
              );
            }
            )
          ],
        ));
  }

  _chatWithVendor(Product product) {
    if(widget.appStateModel.user?.id != null &&
        widget.appStateModel.user.id > 0) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return ChatPage(
            chatId: widget.appStateModel.user.id.toString() + product.vendor.id.toString(), vendorId: product.vendor.id.toString(), vendorName: product.vendor.name, vendorAvatar: product.vendor.icon
        );
      }));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Login();
      }));
    }
  }

  Future<void> addToCart(BuildContext context, Product product) async {
    setState(() {
      addingToCart = true;
    });
    var data = new Map<String, dynamic>();
    data['product_id'] = product.id.toString();
    //data['add-to-cart'] = product.id.toString();
    data['quantity'] = _quantity.toString();
    var doAdd = true;
    if (product.type == 'variable' &&
        product.variationOptions != null) {
      for (var i = 0; i < product.variationOptions.length; i++) {
        if (product.variationOptions[i].selected != null) {
          data['variation[attribute_' + product.variationOptions[i].attribute.toLowerCase() + ']'] = product.variationOptions[i].selected;
          data['attribute_pa_' + product.variationOptions[i].attribute.toLowerCase()] = product.variationOptions[i].selected;
        } else if (product.variationOptions[i].selected == null &&
            product.variationOptions[i].options.length != 0) {
          showSnackBarError(context, widget.appStateModel.blocks.localeText.select + ' ' + product.variationOptions[i].name);
          doAdd = false;
          break;
        } else if (product.variationOptions[i].selected == null &&
            product.variationOptions[i].options.length == 0) {
          setState(() {
            product.stockStatus = 'outofstock';
          });
          doAdd = false;
          break;
        }
      }
      if (product.variationId != null) {
        data['variation_id'] = product.variationId;
      }
    }
    if (doAdd) {
      if (addonFormKey != null && addonFormKey.currentState.validate()) {
        addonFormKey.currentState.save();
        data.addAll(addOnsFormData);
      }
      await widget.appStateModel.addToCart(data, context);
    }
    setState(() {
      addingToCart = false;
    });
  }

  Future<void> buyNow(BuildContext context, Product product) async {
    setState(() {
      buyingNow = true;
    });
    var data = new Map<String, dynamic>();
    data['product_id'] = product.id.toString();
    //data['add-to-cart'] = product.id.toString();
    data['quantity'] = _quantity.toString();
    var doAdd = true;
    if (product.type == 'variable' &&
        product.variationOptions != null) {
      for (var i = 0; i < product.variationOptions.length; i++) {
        if (product.variationOptions[i].selected != null) {
          data['variation[attribute_' + product.variationOptions[i].attribute.toLowerCase() + ']'] = product.variationOptions[i].selected;
          data['attribute_pa_' + product.variationOptions[i].attribute.toLowerCase()] = product.variationOptions[i].selected;
        } else if (product.variationOptions[i].selected == null &&
            product.variationOptions[i].options.length != 0) {
          showSnackBarError(context, widget.appStateModel.blocks.localeText.select + ' ' + product.variationOptions[i].name);
          doAdd = false;
          break;
        } else if (product.variationOptions[i].selected == null &&
            product.variationOptions[i].options.length == 0) {
          setState(() {
            product.stockStatus = 'outofstock';
          });
          doAdd = false;
          break;
        }
      }
      if (product.variationId != null) {
        data['variation_id'] = product.variationId;
      }
    }
    if (doAdd) {
      if (addonFormKey != null && addonFormKey.currentState.validate()) {
        addonFormKey.currentState.save();
        data.addAll(addOnsFormData);
      }
      await widget.appStateModel.addToCart(data, context);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => CartPage(),
          ));
    }
    setState(() {
      buyingNow = false;
    });
  }

  Widget _buildQuantityInput() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: PrimaryColorOverride(
          child: TextFormField(
            initialValue: _quantity.toString(),
            decoration: InputDecoration(labelText: 'Quantity'),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                _quantity = int.parse(value);
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _productAttributes(Product product) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        return Container(
            padding: EdgeInsets.fromLTRB(16, 6, 16, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(product.attributes[index].name, style: Theme.of(context).textTheme.subtitle2,),
                Text(parseHtmlString(_getOptions(product.attributes[index].options)))
              ],
            ),
            height: 30.0);
      }, childCount: product.attributes.length,
      ),
    );
  }

  String _getOptions(List<String> options) {
    String s = '';
    for(var i = 0; i < options.length; i++) {
      s = s + options[i];
      if(options.length > i + 1) {
        s = ' ';
      }
    }
    return s;
  }
}

class CartIcon extends StatelessWidget {
  const CartIcon({
    Key key,
    @required this.context,
  }) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        IconButton(
          icon: Icon(
            MStoreIcons.shopping_basket_2_line,
            semanticLabel: 'Cart',
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => CartPage(),
                ));
          },
        ),
        Positioned(
          top: 2,
          right: 2.0,
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => CartPage(),
                  ));
            },
            child: ScopedModelDescendant<AppStateModel>(
                builder: (context, child, model) {
                  if (model.count != 0) {
                    return Card(
                        elevation: 0,
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                        color: Colors.red,
                        child: Container(
                            padding: EdgeInsets.all(2),
                            constraints: BoxConstraints(minWidth: 20.0),
                            child: Center(
                                child: Text(
                                  model.count.toString(),
                                  style: Theme.of(context).primaryTextTheme.bodyText1.copyWith(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800),
                                ))));
                  } else
                    return Container();
                }),
          ),
        )
      ],
    );
  }
}
