import 'dart:async';

import 'package:barrier_gate/rpp/add_checkpion_list_view/add_checkpion_list_view_widget.dart';
import 'package:barrier_gate/rpp/checkpoint_list_r_p_p_list_view/checkpoint_list_r_p_p_list_view_widget.dart';
import 'package:barrier_gate/rpp/scan_q_r_code_checkpion/scan_q_r_code_checkpion_widget.dart';
import 'package:barrier_gate/rpp/visitorcarregistration/visitorcarregistration_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '/index.dart';
import '/main.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/lat_lng.dart';
import '/flutter_flow/place.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'serialization_util.dart';

export 'package:go_router/go_router.dart';
export 'serialization_util.dart';

const kTransitionInfoKey = '__transition_info__';

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
      errorBuilder: (context, state) => appStateNotifier.showSplashImage
          ? Builder(
              builder: (context) => Container(
                color: FlutterFlowTheme.of(context).primaryBackground,
                child: Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 250.0,
                    height: 250.0,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            )
          : LoginListViewWidget(),
      routes: [
        FFRoute(
          name: '_initialize',
          path: '/',
          builder: (context, _) => appStateNotifier.showSplashImage
              ? Builder(
                  builder: (context) => Container(
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    child: Center(
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 250.0,
                        height: 250.0,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                )
              : LoginListViewWidget(),
        ),
        FFRoute(
          name: 'login_list_view',
          path: '/loginListView',
          builder: (context, params) => LoginListViewWidget(),
        ),
        FFRoute(
          name: 'home_list_view',
          path: '/homeListView',
          builder: (context, params) => HomeListViewWidget(),
        ),
        FFRoute(
          name: 'check_infomation_list_view',
          path: '/checkInfomationListView',
          builder: (context, params) => CheckInfomationListViewWidget(
              villageproject_detail_id: 0, officerID: 0),
        ),
        FFRoute(
          name: 'my_project_list_widget',
          path: '/myProjectListWidget',
          builder: (context, params) => MyProjectListWidgetWidget(),
        ),
        FFRoute(
          name: 'register_external_person_view',
          path: '/registerExternalPersonView',
          builder: (context, params) => RegisterExternalPersonViewWidget(),
        ),
        FFRoute(
          name: 'register_car_list_view',
          path: '/registerCarListView',
          builder: (context, params) => RegisterCarListViewWidget(),
        ),
        FFRoute(
          name: 'cardetail',
          path: '/cardetail',
          builder: (context, params) => CardetailWidget(),
        ),
        FFRoute(
          name: 'car_external_person',
          path: '/carExternalPerson',
          builder: (context, params) => CarExternalPersonWidget(),
        ),
        FFRoute(
          name: 'notify',
          path: '/notify',
          builder: (context, params) => NotifyWidget(),
        ),
        FFRoute(
          name: 'me_list_view',
          path: '/meListView',
          builder: (context, params) => MeListViewWidget(),
        ),
        FFRoute(
          name: 'profile_list_view',
          path: '/profileListView',
          builder: (context, params) => ProfileListViewWidget(),
        ),
        FFRoute(
          name: 'Changepassword',
          path: '/changepassword',
          builder: (context, params) => ChangepasswordWidget(),
        ),
        FFRoute(
          name: 'padpa',
          path: '/padpa',
          builder: (context, params) => PadpaWidget(),
        ),
        FFRoute(
          name: 'car_external_person_histoty',
          path: '/carExternalPersonHistoty',
          builder: (context, params) => CarExternalPersonHistotyWidget(),
        ),
        FFRoute(
          name: 'register_reverse_external_person_view',
          path: '/registerReverseExternalPersonView',
          builder: (context, params) =>
              RegisterReverseExternalPersonViewWidget(),
        ),
        FFRoute(
          name: 'signin',
          path: '/signin',
          builder: (context, params) => SigninWidget(),
        ),
        FFRoute(
          name: 'pdpa',
          path: '/pdpa',
          builder: (context, params) => PdpaWidget(),
        ),
        FFRoute(
          name: 'signup',
          path: '/signup',
          builder: (context, params) => SignupWidget(),
        ),
        FFRoute(
          name: 'home_RPP',
          path: '/homeRPP',
          builder: (context, params) => HomeRPPWidget(),
        ),
        FFRoute(
          name: 'me_RPP_list_view',
          path: '/meRPPListView',
          builder: (context, params) => MeRPPListViewWidget(),
        ),
        FFRoute(
          name: 'externalvehicleregistration',
          path: '/externalvehicleregistration',
          builder: (context, params) => ExternalvehicleregistrationWidget(),
        ),
        FFRoute(
          name: 'check_infomation_externalvehicleregistration',
          path: '/checkInfomationExternalvehicleregistration',
          builder: (context, params) =>
              CheckInfomationExternalvehicleregistrationWidget(),
        ),
        FFRoute(
          name: 'scan_QR_code',
          path: '/scanQRCode',
          builder: (context, params) => ScanQRCodeWidget(),
        ),
        FFRoute(
          name: 'CheckpointList_RPP_list_view',
          path: '/checkpointListRPPListView',
          builder: (context, params) => CheckpointListRPPListViewWidget(),
        ),
        FFRoute(
          name: 'scan_QR_code_checkpion',
          path: '/scanQRCodeCheckpion',
          builder: (context, params) => ScanQRCodeCheckpionWidget(),
        ),
        FFRoute(
            name: 'add_checkpion_list_view',
            path: '/addCheckpionListView',
            builder: (context, params) => AddCheckpionListViewWidget(
                  qrLocationId: '',
                  villageProjectId: '',
                  locationName: '',
                  latitude: 0.00,
                  longitude: 0.00,
                  isEditMode: true,
                )),
        FFRoute(
          name: 'Visitorcarregistration',
          path: '/visitorcarregistration',
          builder: (context, params) => VisitorcarregistrationWidget(),
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
                  child: child,
                  transitionDuration: transitionInfo.duration,
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          PageTransition(
                    type: transitionInfo.transitionType,
                    duration: transitionInfo.duration,
                    reverseDuration: transitionInfo.duration,
                    alignment: transitionInfo.alignment,
                    child: child,
                  ).buildTransitions(
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ),
                )
              : MaterialPage(key: state.pageKey, child: child);
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
