// ENDPOINT
import 'package:flutter/material.dart';

const baseURL = 'https://tes.sipandawa.com/public/api';
const loginURL = '$baseURL/login';
const registerURL = '$baseURL/register';
const logoutURL = '$baseURL/logout';
const userURL = '$baseURL/user';
const postURL = '$baseURL/posts';
const commentsURL = '$baseURL/comments';

// errors
const serverError = 'Server error';
const unauthorized = 'Unauthorized';
const somethingWentWrong = 'Someting went wrong, try again';

// inputdecoration
InputDecoration kInputDecoration(String label) {
  return InputDecoration(
    labelText: label,
    contentPadding: const EdgeInsets.all(10),
    border: const OutlineInputBorder(
      borderSide: BorderSide(
        width: 1,
        color: Colors.black,
      ),
    ),
  );
}

// textbutton
TextButton kTextButton(String label, Function onPressed) {
  return TextButton(
    onPressed: () => onPressed(),
    child: Text(
      label,
      style: TextStyle(
        color: Colors.white,
      ),
    ),
    style: ButtonStyle(
      backgroundColor: MaterialStateColor.resolveWith((states) => Colors.blue),
      padding: MaterialStateProperty.resolveWith(
        (states) => const EdgeInsets.symmetric(vertical: 10),
      ),
    ),
  );
}

// login register
Row kLoginRegister(String text, String label, Function onTap) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(text),
      GestureDetector(
        child: Text(
          label,
          style: TextStyle(
            color: Colors.blue,
          ),
        ),
        onTap: () => onTap(),
      )
    ],
  );
}
