import 'package:models/models.dart';

class DemoMessageResponse implements MessageResponse {
  const DemoMessageResponse(this.message);

  @override
  final String message;
}
