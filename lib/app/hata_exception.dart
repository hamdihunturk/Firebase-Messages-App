class Hatalar {
  static String goster(String hatacodu) {
    switch (hatacodu) {
      case 'email-already-in-use':
        return "Bu e-mail adresi zaten var.Lüften farklı bir mail kullanınız";
      case 'user-not-found':
        return "Kullanici bulunamiyor";
      default:
        return 'bir hata olustu';
    }
  }
}
