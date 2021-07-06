import 'package:flutter/material.dart';
import './../../../../models/product_model.dart';
import '../../../../functions.dart';

class PriceWidget extends StatelessWidget {
  const PriceWidget({
    Key key,
    @required this.onSale,
    @required this.product,
  }) : super(key: key);

  final bool onSale;
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        Text(onSale && (product.formattedSalesPrice != null &&
            product.formattedSalesPrice.isNotEmpty)
            ? parseHtmlString(product.formattedSalesPrice) : '',
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                )),
        onSale ? SizedBox(width: 6.0) : SizedBox(width: 0.0),
        Text(
            (product.formattedPrice != null &&
                    product.formattedPrice.isNotEmpty)
                ? parseHtmlString(product.formattedPrice)
                : '',
            style: onSale && (product.formattedSalesPrice != null &&
    product.formattedSalesPrice.isNotEmpty) ? Theme.of(context).textTheme.caption.copyWith(
              decoration: TextDecoration.lineThrough,
              decorationColor: Theme.of(context).textTheme.caption.color.withOpacity(0.5)
            ) : Theme.of(context).textTheme.bodyText1.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w800,
            )
        ),
      ],
    );
  }
}

class VariationPriceWidget extends StatelessWidget {
  const VariationPriceWidget({
    Key key,
    @required this.selectedVariation,
  }) : super(key: key);

  final AvailableVariation selectedVariation;

  @override
  Widget build(BuildContext context) {
    bool onSale = (selectedVariation.formattedSalesPrice != null &&
        selectedVariation.formattedSalesPrice.isNotEmpty);
    return Wrap(
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        Text(onSale ? parseHtmlString(selectedVariation.formattedSalesPrice) : '',
            style: Theme.of(context).textTheme.bodyText1.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w800,
            )),
        onSale ? SizedBox(width: 6.0) : SizedBox(width: 0.0),
        Text(
            (selectedVariation.formattedPrice != null &&
                selectedVariation.formattedPrice.isNotEmpty)
                ? parseHtmlString(selectedVariation.formattedPrice)
                : '',
            style: onSale && (selectedVariation.formattedSalesPrice != null &&
                selectedVariation.formattedSalesPrice.isNotEmpty) ? Theme.of(context).textTheme.caption.copyWith(
                decoration: TextDecoration.lineThrough,
                decorationColor: Theme.of(context).textTheme.caption.color.withOpacity(0.5)
            ) : Theme.of(context).textTheme.bodyText1.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w800,
            )
        ),
        SizedBox(width: 4.0),
        onSale ? Text((selectedVariation.displayRegularPrice - selectedVariation.displayPrice).round().toString() + '% OFF', style: Theme.of(context).textTheme.bodyText2.copyWith(
          color: Colors.deepOrange
        )) : Container()
      ],
    );
  }
}
