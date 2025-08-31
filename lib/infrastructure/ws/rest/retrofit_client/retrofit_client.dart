import 'package:dio/dio.dart' hide Headers;
import 'package:investtrack/infrastructure/ws/models/responses/authentication_response/prepare_verification_response/prepare_verification_response.dart';
import 'package:investtrack/infrastructure/ws/models/responses/authentication_response/sign_in_response/sign_in_response.dart';
import 'package:investtrack/infrastructure/ws/models/responses/authentication_response/sign_up_response/sign_up_response.dart';
import 'package:investtrack/infrastructure/ws/models/responses/authentication_response/verification_response.dart';
import 'package:investtrack/infrastructure/ws/models/responses/change_percentage_response/change_percentage_response.dart';
import 'package:investtrack/infrastructure/ws/models/responses/created_investment_response/created_investment_response.dart';
import 'package:investtrack/infrastructure/ws/models/responses/delete_account_response/delete_account_response.dart';
import 'package:investtrack/infrastructure/ws/models/responses/delete_investment_response/delete_investment_response.dart';
import 'package:investtrack/infrastructure/ws/models/responses/exchange_rate_response/exchange_rate_response.dart';
import 'package:investtrack/infrastructure/ws/models/responses/investments_response/investments_response.dart';
import 'package:investtrack/infrastructure/ws/models/responses/price_change_response/price_change_response.dart';
import 'package:investtrack/infrastructure/ws/models/responses/sign_out_response/sign_out_response.dart';
import 'package:investtrack/infrastructure/ws/models/responses/updated_investment_response/updated_investment_response.dart';
import 'package:investtrack/res/constants/constants.dart' as constants;
import 'package:models/models.dart';
import 'package:retrofit/retrofit.dart';

part 'retrofit_client.g.dart';

/// https://pub.dev/packages/retrofit
@RestApi()
abstract class RetrofitClient implements RestClient {
  factory RetrofitClient(Dio dio, {String baseUrl}) = _RetrofitClient;

  @override
  @POST(
    'https://clerk.${constants.domain}/v1/client/sign_ins?_clerk_js_version=5.20.0',
  )
  @FormUrlEncoded()
  Future<SignInResponse> signEmail(@Field('identifier') String identifier);

  @override
  @POST(
    'https://clerk.${constants.domain}/v1/client/sign_ins?_clerk_js_version=5.14.0',
  )
  @FormUrlEncoded()
  Future<SignInResponse> signIn(
    @Field('identifier') String identifier,
    @Field('password') String password,
    // This always will be of value `password`.
    @Field('strategy') String strategy,
  );

  @override
  @GET(
    'https://clerk.${constants.domain}/v1/environment?_clerk_js_version=5.14.0',
  )
  Future<SignOutResponse> signOut();

  //TODO: remove due to it is not used.
  @Deprecated('There is no replacement at this moment.')
  @override
  @POST(
    'https://clerk.${constants.domain}/v1/client/sign_ups?_clerk_js_version=5.17.0',
  )
  @FormUrlEncoded()
  Future<SignUpResponse> signUp(
    @Field('email_address') String emailAddress,
    @Field('password') String password,
  );

  //TODO: remove due to it is not used.
  /// The [RegisterResponse.id] will be used to call
  /// `https://clerk.${constants.domain}/v1/client/sign_ups/[RegisterResponse.id]/
  /// prepare_verification?_clerk_js_version=5.15.0`
  /// it will send a 6 digits code to the `emailAddress` from the
  /// [signUp] form.
  @Deprecated('There is no replacement at this moment.')
  @override
  @POST(
    'https://clerk.${constants.domain}/v1/client/sign_ups/{id}/prepare_verification?'
    '_clerk_js_version=5.17.0',
  )
  @FormUrlEncoded()
  Future<PrepareVerificationResponse> prepare(
    @Path() String id,
    // This value is always `email_code`.
    @Field('strategy') String strategy,
  );

  //TODO: remove due to it is not used.
  /// This call should be called after [prepare] and it will expect the code
  /// received on `emailAddress` from the [signUp] form.
  @Deprecated('There is no replacement at this moment.')
  @override
  @POST(
    'https://clerk.${constants.domain}/v1/client/sign_ups/{id}/attempt_verification?'
    '_clerk_js_version=5.15.0',
  )
  @FormUrlEncoded()
  Future<VerificationResponse> verify(
    @Path() String id,
    @Field('code') String code,
    // This value is always `email_code`.
    @Field('strategy') String strategy,
  );

  @override
  @GET('investments')
  Future<InvestmentsResponse> getInvestments(
    @Query('userId') String userId,
    @Query('page') int page,
    @Query('itemsPerPage') int itemsPerPage,
  );

  @override
  @POST('investments')
  Future<CreatedInvestmentResponse> createInvestment(
    @Body() Investment investment,
  );

  @override
  @PUT('investments')
  Future<UpdatedInvestmentResponse> updateInvestment(
    @Body() Investment investment,
  );

  @override
  @DELETE('investments')
  Future<DeleteInvestmentResponse> deleteInvestment(
    @Query('userId') String userId,
    @Query('investmentId') int investmentId,
  );

  @override
  @DELETE('delete-user')
  Future<DeleteAccountResponse> deleteAccount(@Query('userId') String userId);

  @override
  @GET('https://api.exchangerate-api.com/v4/latest/{fromCurrency}')
  Future<ExchangeRateResponse> getExchangeRate(
    @Path('fromCurrency') String fromCurrency,
  );

  @override
  @GET('change')
  Future<PriceChangeResponse> fetchPriceChange(@Query('ticker') String ticker);

  @override
  @GET('change-percentage')
  Future<ChangePercentageResponse> fetchChangePercentage(
    @Query('ticker') String ticker,
  );
}
