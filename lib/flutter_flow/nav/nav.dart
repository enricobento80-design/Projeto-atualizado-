import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '/backend/schema/structs/index.dart';

import '/main.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/lat_lng.dart';
import '/flutter_flow/place.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'serialization_util.dart';

import '/index.dart';

export 'package:go_router/go_router.dart';
export 'serialization_util.dart';

const kTransitionInfoKey = '__transition_info__';

GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._();

  static AppStateNotifier? _instance;
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  bool showSplashImage = true;

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }
}

GoRouter createRouter(AppStateNotifier appStateNotifier) => GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: appStateNotifier,
      navigatorKey: appNavigatorKey,
      errorBuilder: (context, state) => appStateNotifier.showSplashImage
          ? Builder(
              builder: (context) => Container(
                color: Colors.transparent,
                child: Image.asset(
                  'assets/images/Gemini_Generated_Image_u2qth5u2qth5u2qt.jpg',
                  fit: BoxFit.contain,
                ),
              ),
            )
          : MenucardapioCopyCopy2Widget(),
      routes: [
        FFRoute(
          name: '_initialize',
          path: '/',
          builder: (context, _) => appStateNotifier.showSplashImage
              ? Builder(
                  builder: (context) => Container(
                    color: Colors.transparent,
                    child: Image.asset(
                      'assets/images/Gemini_Generated_Image_u2qth5u2qth5u2qt.jpg',
                      fit: BoxFit.contain,
                    ),
                  ),
                )
              : MenucardapioCopyCopy2Widget(),
        ),
        FFRoute(
          name: LoginWidget.routeName,
          path: LoginWidget.routePath,
          builder: (context, params) => LoginWidget(),
        ),
        FFRoute(
          name: MenucardapioWidget.routeName,
          path: MenucardapioWidget.routePath,
          builder: (context, params) => MenucardapioWidget(),
        ),
        FFRoute(
          name: DetalhesdoitemWidget.routeName,
          path: DetalhesdoitemWidget.routePath,
          builder: (context, params) => DetalhesdoitemWidget(
            produtoId: params.getParam(
              'produtoId',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: CartCheckoutWidget.routeName,
          path: CartCheckoutWidget.routePath,
          builder: (context, params) => CartCheckoutWidget(),
        ),
        FFRoute(
          name: MenudacontaWidget.routeName,
          path: MenudacontaWidget.routePath,
          builder: (context, params) => MenudacontaWidget(),
        ),
        FFRoute(
          name: CadastroWidget.routeName,
          path: CadastroWidget.routePath,
          builder: (context, params) => CadastroWidget(),
        ),
        FFRoute(
          name: VerificaoWidget.routeName,
          path: VerificaoWidget.routePath,
          builder: (context, params) => VerificaoWidget(
            email: params.getParam('email', ParamType.String),
          ),
        ),
        FFRoute(
          name: CadastroenderecoWidget.routeName,
          path: CadastroenderecoWidget.routePath,
          builder: (context, params) => CadastroenderecoWidget(
            origemCadastro:
                params.getParam<bool>('origemCadastro', ParamType.bool) ??
                    false,
            enderecoId: params.getParam('enderecoId', ParamType.int),
          ),
        ),
        FFRoute(
          name: MenucardapioCopyWidget.routeName,
          path: MenucardapioCopyWidget.routePath,
          builder: (context, params) => MenucardapioCopyWidget(),
        ),
        FFRoute(
          name: PaginadenotificacaoWidget.routeName,
          path: PaginadenotificacaoWidget.routePath,
          builder: (context, params) => PaginadenotificacaoWidget(),
        ),
        FFRoute(
          name: DadosdacontaWidget.routeName,
          path: DadosdacontaWidget.routePath,
          builder: (context, params) => DadosdacontaWidget(),
        ),
        FFRoute(
          name: MeiosdepagamentoWidget.routeName,
          path: MeiosdepagamentoWidget.routePath,
          builder: (context, params) => MeiosdepagamentoWidget(),
        ),
        FFRoute(
          name: EnderecosWidget.routeName,
          path: EnderecosWidget.routePath,
          builder: (context, params) => EnderecosWidget(),
        ),
        FFRoute(
          name: MeuspedidosWidget.routeName,
          path: MeuspedidosWidget.routePath,
          builder: (context, params) => MeuspedidosWidget(),
        ),
        FFRoute(
          name: MenucardapioCopyCopyWidget.routeName,
          path: MenucardapioCopyCopyWidget.routePath,
          builder: (context, params) => MenucardapioCopyCopyWidget(),
        ),
        FFRoute(
          name: MenucardapioCopyCopy2Widget.routeName,
          path: MenucardapioCopyCopy2Widget.routePath,
          builder: (context, params) => MenucardapioCopyCopy2Widget(),
        ),
        FFRoute(
          name: AcessobloqueadoWidget.routeName,
          path: AcessobloqueadoWidget.routePath,
          builder: (context, params) => AcessobloqueadoWidget(
            email: params.getParam('email', ParamType.String),
          ),
        ),
        FFRoute(
          name: RecuperarsenhaWidget.routeName,
          path: RecuperarsenhaWidget.routePath,
          builder: (context, params) => RecuperarsenhaWidget(
            email: params.getParam('email', ParamType.String),
          ),
        ),
        FFRoute(
          name: PagamentoWidget.routeName,
          path: PagamentoWidget.routePath,
          builder: (context, params) => PagamentoWidget(),
        ),
        FFRoute(
          name: NovocartaoWidget.routeName,
          path: NovocartaoWidget.routePath,
          builder: (context, params) => NovocartaoWidget(),
        ),
        FFRoute(
          name: PagarpixWidget.routeName,
          path: PagarpixWidget.routePath,
          builder: (context, params) => PagarpixWidget(
            pedidoId: params.getParam('pedidoId', ParamType.int),
          ),
        ),
        FFRoute(
          name: PagamentorealizadoWidget.routeName,
          path: PagamentorealizadoWidget.routePath,
          builder: (context, params) => PagamentorealizadoWidget(
            pedidoId: params.getParam('pedidoId', ParamType.int),
          ),
        ),
        FFRoute(
          name: AcompanharpedidoWidget.routeName,
          path: AcompanharpedidoWidget.routePath,
          builder: (context, params) => AcompanharpedidoWidget(
            pedidoId: params.getParam('pedidoId', ParamType.int),
          ),
        ),
        FFRoute(
          name: AvaliarpedidoWidget.routeName,
          path: AvaliarpedidoWidget.routePath,
          builder: (context, params) => AvaliarpedidoWidget(
            pedidoId: params.getParam('pedidoId', ParamType.int),
          ),
        ),
        FFRoute(
          name: MeuspontosWidget.routeName,
          path: MeuspontosWidget.routePath,
          builder: (context, params) => MeuspontosWidget(),
        )
      ].map((r) => r.toRoute(appStateNotifier)).toList(),
    );

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
}

extension NavigationExtensions on BuildContext {
  void safePop() {
    // If there is only one route on the stack, navigate to the initial
    // page instead of popping.
    if (canPop()) {
      pop();
    } else {
      go('/');
    }
  }
}

extension _GoRouterStateExtensions on GoRouterState {
  Map<String, dynamic> get extraMap =>
      extra != null ? extra as Map<String, dynamic> : {};
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(pathParameters)
    ..addAll(uri.queryParameters)
    ..addAll(extraMap);
  TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey)
      ? extraMap[kTransitionInfoKey] as TransitionInfo
      : TransitionInfo.appDefault();
}

class FFParameters {
  FFParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};

  // Parameters are empty if the params map is empty or if the only parameter
  // present is the special extra parameter reserved for the transition info.
  bool get isEmpty =>
      state.allParams.isEmpty ||
      (state.allParams.length == 1 &&
          state.extraMap.containsKey(kTransitionInfoKey));
  bool isAsyncParam(MapEntry<String, dynamic> param) =>
      asyncParams.containsKey(param.key) && param.value is String;
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);
  Future<bool> completeFutures() => Future.wait(
        state.allParams.entries.where(isAsyncParam).map(
          (param) async {
            final doc = await asyncParams[param.key]!(param.value)
                .onError((_, __) => null);
            if (doc != null) {
              futureParamValues[param.key] = doc;
              return true;
            }
            return false;
          },
        ),
      ).onError((_, __) => [false]).then((v) => v.every((e) => e));

  dynamic getParam<T>(
    String paramName,
    ParamType type, {
    bool isList = false,
    StructBuilder<T>? structBuilder,
  }) {
    if (futureParamValues.containsKey(paramName)) {
      return futureParamValues[paramName];
    }
    if (!state.allParams.containsKey(paramName)) {
      return null;
    }
    final param = state.allParams[paramName];
    // Got parameter from `extras`, so just directly return it.
    if (param is! String) {
      return param;
    }
    // Return serialized value.
    return deserializeParam<T>(
      param,
      type,
      isList,
      structBuilder: structBuilder,
    );
  }
}

class FFRoute {
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, FFParameters) builder;
  final List<GoRoute> routes;

  GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
        name: name,
        path: path,
        pageBuilder: (context, state) {
          fixStatusBarOniOS16AndBelow(context);
          final ffParams = FFParameters(state, asyncParams);
          final page = ffParams.hasFutures
              ? FutureBuilder(
                  future: ffParams.completeFutures(),
                  builder: (context, _) => builder(context, ffParams),
                )
              : builder(context, ffParams);
          final child = page;

          final transitionInfo = state.transitionInfo;
          return transitionInfo.hasTransition
              ? CustomTransitionPage(
                  key: state.pageKey,
                  name: state.name,
                  child: child,
                  transitionDuration: transitionInfo.duration,
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          PageTransition(
                    type: transitionInfo.transitionType,
                    duration: transitionInfo.duration,
                    reverseDuration: transitionInfo.duration,
                    alignment: transitionInfo.alignment,
                    curve: transitionInfo.transitionType ==
                            PageTransitionType.scale
                        ? const Interval(0.0, 0.5)
                        : Curves.linear,
                    child: child,
                  ).buildTransitions(
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ),
                )
              : MaterialPage(
                  key: state.pageKey, name: state.name, child: child);
        },
        routes: routes,
      );
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.alignment,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;

  static TransitionInfo appDefault() => TransitionInfo(hasTransition: false);
}

class RootPageContext {
  const RootPageContext(this.isRootPage, [this.errorRoute]);
  final bool isRootPage;
  final String? errorRoute;

  static bool isInactiveRootPage(BuildContext context) {
    final rootPageContext = context.read<RootPageContext?>();
    final isRootPage = rootPageContext?.isRootPage ?? false;
    final location = GoRouterState.of(context).uri.toString();
    return isRootPage &&
        location != '/' &&
        location != rootPageContext?.errorRoute;
  }

  static Widget wrap(Widget child, {String? errorRoute}) => Provider.value(
        value: RootPageContext(true, errorRoute),
        child: child,
      );
}

extension GoRouterLocationExtension on GoRouter {
  String getCurrentLocation() {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }
}
