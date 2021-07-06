import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../../models/app_state_model.dart';
import '../../../models/product_model.dart';
import '../../../ui/products/product_detail/product_detail2.dart';
import '../../../ui/products/product_grid/products_widgets/price_widget.dart';
import '../../../functions.dart';
import 'add_to_cart.dart';
import 'product_label.dart';

class ProductItemCard extends StatefulWidget {
  final Product product;

  const ProductItemCard({Key key, this.product}) : super(key: key);
  @override
  _ProductItemCardState createState() => _ProductItemCardState();
}

class _ProductItemCardState extends State<ProductItemCard> {

  AvailableVariation _selectedVariation;
  int percentOff = 0;

  @override
  void initState() {
    if(widget.product.availableVariations.length > 0) {
      _selectedVariation = widget.product.availableVariations.first;
    }
    if ((widget.product.salePrice != null && widget.product.salePrice != 0)) {
      percentOff = (((widget.product.regularPrice - widget.product.salePrice) / widget.product.regularPrice) * 100).round();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle _textStyle = Theme.of(context).textTheme.caption.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w700
    );
    return Stack(
      children: [
        ScopedModelDescendant<AppStateModel>(
            builder: (context, child, model) {
              return Card(
                clipBehavior: Clip.antiAlias,
                elevation: 0,
                child: Stack(
                  children: [
                    InkWell(
                      onTap: () => onProductClick(),
                      child: Container(
                        child: Column(
                          children: [
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Container(
                                  height: (MediaQuery.of(context).size.width / 2) - ( 2 * 4),
                                  child: Image.network(widget.product.images[0].src,fit: BoxFit.fill,),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        widget.product.tags.contains('fresh') ? Container(
                                          height: 18,
                                          padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                                          decoration: BoxDecoration(
                                            color: Color(0xffeeeeee),
                                            borderRadius: BorderRadius.all(Radius.circular(2)
                                            ),),
                                          child: Center(
                                            child: Row(
                                              children: [
                                                Icon(Icons.fiber_manual_record_sharp, size: 9, color: Colors.deepOrange),
                                                SizedBox(width: 4),
                                                Text('Fresh',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 8,
                                                    color: Colors.black45,
                                                    fontWeight: FontWeight.w600,
                                                    //letterSpacing: 1
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ) : Container(),
                                        Spacer(),
                                        widget.product.tags.contains('express') ? Container(
                                          height: 18,
                                          padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                                          decoration: BoxDecoration(
                                            color: Color(0xffeeeeee),
                                            borderRadius: BorderRadius.all(Radius.circular(2)
                                            ),),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              //Image.asset('lib/assets/images/bike.webp',width: 20, height: 8,fit: BoxFit.fill, color:Colors.grey),
                                              Text('Express',
                                                style: TextStyle(
                                                  fontSize: 8,
                                                  color: Colors.black45,
                                                  fontWeight: FontWeight.w600,
                                                  //letterSpacing: 1
                                                ),
                                              ),
                                              SizedBox(width: 4),
                                              Icon(Icons.pedal_bike_rounded, size: 10, color: Colors.black45,),
                                              /**/
                                            ],
                                          ),
                                        ) : Container(),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(widget.product.name, maxLines: 2, style: Theme.of(context).textTheme.bodyText2,),
                                    ),
                                    widget.product.ratingCount != 0 ? Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 16,
                                            decoration: BoxDecoration(
                                              color: Color(0xffeeeeee),
                                              borderRadius: BorderRadius.circular(8
                                              ),),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(vertical: 2,horizontal: 8),
                                              decoration: BoxDecoration(
                                                color: Colors.deepOrange.withOpacity(.1),
                                                borderRadius: BorderRadius.circular(8),),
                                              child: Center(
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Text(widget.product.averageRating,
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 9,
                                                        color: Colors.deepOrange,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                    SizedBox(width: 4),
                                                    Icon(Icons.star,size: 10,color: Colors.deepOrange,)
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Text(widget.product.ratingCount.toString() + ' Ratings',
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context).textTheme.caption/*TextStyle(
                                            fontSize: 9,
                                            color: Colors.black38,
                                            fontWeight: FontWeight.w600,
                                            //letterSpacing: 1
                                          ),*/
                                          ),
                                        ],
                                      ),
                                    ) : Container(),
                                    SizedBox(height: 16),
                                    model.blocks.settings.listingAddToCart ? Column(
                                      children: [
                                        widget.product.availableVariations.length > 0 ? Column(
                                          children: [
                                            Align(alignment: AlignmentDirectional.centerStart, child: VariationPriceWidget(selectedVariation: _selectedVariation)),
                                            SizedBox(height: 8,),
                                            Container(
                                              height: 25,
                                              child: OutlineButton(
                                                  padding: EdgeInsets.all(5),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(getTitle(_selectedVariation),style: _textStyle,),
                                                      Icon(Icons.keyboard_arrow_down, size: 16, color: Theme.of(context).textTheme.caption.color)
                                                    ],
                                                  ),
                                                  onPressed: (){
                                                    _selectVariant(context);
                                                  },
                                                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(2.0))
                                              ),
                                            ),
                                          ],
                                        ) : Align(alignment: AlignmentDirectional.centerStart, child: PriceWidget(product: widget.product, onSale: widget.product.onSale)),
                                        SizedBox(height: 16),
                                        AddToCart(product: widget.product, model: model, variation: _selectedVariation),
                                      ],
                                    ) : Align(alignment: AlignmentDirectional.centerStart, child: PriceWidget(product: widget.product, onSale: widget.product.onSale)),
                                    SizedBox(height: 8),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                        top: 30,
                        left: 0,
                        child: ProductLabel(widget.product.tags)
                    ),
                  ],
                ),
              );
            }
        ),
        percentOff != 0 ? Positioned(
          top: 4,
          left: 4,
          child: Container(
            height: 18,
            width:  MediaQuery.of(context).size.width * .35/2,
            decoration: BoxDecoration(
              color: Colors.deepOrange,//Theme.of(context).accentColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  bottomRight: Radius.circular(6)
              ),),
            child: Center(
              child: Text(percentOff.toString() + '% OFF',
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).accentTextTheme.bodyText1.copyWith(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  )
              ),
            ),
          ),
        ) : Container()
      ],
    );
  }

  Future<Product> _selectVariant(BuildContext context) async {
    return await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            backgroundColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
            titlePadding: EdgeInsets.only(top: 10,bottom: 0),
            elevation: 4,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Available quantities for',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black38,
                    fontWeight: FontWeight.w600,
                    //letterSpacing: 1
                  ),),
                SizedBox(height: 8,),
                Text(widget.product.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    //letterSpacing: 1
                  ),
                ),
              ],
            ),
            children: _buildVariationList(),
          );
        });
  }

  _buildVariationList() {
    List<Widget> list = new List<Widget>();
    widget.product.availableVariations.forEach((element) {
      list.add(
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Divider(
            ),
            buildSimpleDialog(context, element),
          ],
        ),
      );
    });
    return list;
  }

  ClipRRect buildSimpleDialog(BuildContext context, AvailableVariation variation) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: Container(
        color: _selectedVariation == variation ? Colors.black87 : Colors.white,
        child: Center(
          child: SimpleDialogOption(
            onPressed: () {
              setState(() {
                _selectedVariation = variation;
              });
              Navigator.of(context).pop();
            },
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(getTitle(variation) , style:TextStyle(
                      fontSize: 12,
                      color: _selectedVariation == variation ? Colors.white : Colors.black87

                  ),),
                  _variationPrice(variation),
                ]
            ),
          ),
        ),
      ),
    );
  }

  getTitle(AvailableVariation variation) {
    var name = '';
    for (var value in variation.option) {
      if(value.value != null)
        name = name + value.value + ' ';
    }
    return name;
  }

  _variationPrice(AvailableVariation variation) {
    if(variation.formattedPrice != null && variation.formattedSalesPrice == null) {
      return Text(parseHtmlString(variation.formattedPrice), style: TextStyle(
        fontWeight: FontWeight.bold,
        color: _selectedVariation == variation ? Colors.white : Colors.black38,
      ));
    } else if(variation.formattedPrice != null && variation.formattedSalesPrice != null) {
      return Row(
        children: [
          Text(parseHtmlString(variation.formattedPrice), style: TextStyle(
            fontSize: 10,
            decoration: TextDecoration.lineThrough,
            color: _selectedVariation == variation ? Colors.white : Colors.black38,
          )),
          SizedBox(width: 4),
          Text(parseHtmlString(variation.formattedSalesPrice), style: TextStyle(
              fontWeight: FontWeight.bold, color: _selectedVariation == variation ? Colors.white : Colors.black
          )),
        ],
      );
    }
  }

  onProductClick() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ProductDetail2(product: widget.product);
    }));
  }
}

