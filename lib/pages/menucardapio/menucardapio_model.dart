import '/components/bottom_nav/bottom_nav_widget.dart';
import '/components/bottom_nav_child/bottom_nav_child_widget.dart';
import '/components/category_pill/category_pill_widget.dart';
import '/components/food_card/food_card_widget.dart';
import '/components/text_field/text_field_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'menucardapio_widget.dart' show MenucardapioWidget;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MenucardapioModel extends FlutterFlowModel<MenucardapioWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for TextField.
  late TextFieldModel textFieldModel;
  // Model for CategoryPill.
  late CategoryPillModel categoryPillModel1;
  // Model for CategoryPill.
  late CategoryPillModel categoryPillModel2;
  // Model for CategoryPill.
  late CategoryPillModel categoryPillModel3;
  // Model for CategoryPill.
  late CategoryPillModel categoryPillModel4;
  // Model for CategoryPill.
  late CategoryPillModel categoryPillModel5;
  // Model for FoodCard.
  late FoodCardModel foodCardModel1;
  // Model for FoodCard.
  late FoodCardModel foodCardModel2;
  // Model for FoodCard.
  late FoodCardModel foodCardModel3;
  // Model for BottomNav.
  late BottomNavModel bottomNavModel;

  @override
  void initState(BuildContext context) {
    textFieldModel = createModel(context, () => TextFieldModel());
    categoryPillModel1 = createModel(context, () => CategoryPillModel());
    categoryPillModel2 = createModel(context, () => CategoryPillModel());
    categoryPillModel3 = createModel(context, () => CategoryPillModel());
    categoryPillModel4 = createModel(context, () => CategoryPillModel());
    categoryPillModel5 = createModel(context, () => CategoryPillModel());
    foodCardModel1 = createModel(context, () => FoodCardModel());
    foodCardModel2 = createModel(context, () => FoodCardModel());
    foodCardModel3 = createModel(context, () => FoodCardModel());
    bottomNavModel = createModel(context, () => BottomNavModel());
  }

  @override
  void dispose() {
    textFieldModel.dispose();
    categoryPillModel1.dispose();
    categoryPillModel2.dispose();
    categoryPillModel3.dispose();
    categoryPillModel4.dispose();
    categoryPillModel5.dispose();
    foodCardModel1.dispose();
    foodCardModel2.dispose();
    foodCardModel3.dispose();
    bottomNavModel.dispose();
  }
}
