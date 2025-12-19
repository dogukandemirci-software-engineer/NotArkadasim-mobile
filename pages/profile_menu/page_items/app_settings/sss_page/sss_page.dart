import 'package:flutter/material.dart';
import 'package:note_arkadasim/components/NA_classic_appbar/NA_classic_appbar.dart';

class SssPage extends StatelessWidget {
  const SssPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> faqList = [
      {
        'question': 'Uygulama ücretsiz mi?',
        'answer':
        'Evet, uygulamanın temel özellikleri tamamen ücretsizdir. Gelecekte bazı gelişmiş özellikler için premium seçenekler eklenebilir.'
      },
      {
        'question': 'Verilerim güvende mi?',
        'answer':
        'Tüm veriler güvenli bir şekilde saklanır ve üçüncü taraflarla paylaşılmaz. Gizlilik politikamıza uygun olarak korunur.'
      },
      {
        'question': 'Hesabımı nasıl silebilirim?',
        'answer':
        'Ayarlar > Hesap > Hesabı Sil adımlarını izleyerek hesabınızı kalıcı olarak silebilirsiniz.'
      },
      {
        'question': 'Uygulama çevrimdışı çalışır mı?',
        'answer':
        'Temel özelliklerin bir kısmı çevrimdışı kullanılabilir. Ancak bazı veriler ve senkronizasyon işlemleri için internet bağlantısı gerekir.'
      },
      {
        'question': 'Destek ekibine nasıl ulaşabilirim?',
        'answer':
        'Bizimle iletişime geçmek için destek sayfasını kullanabilir veya e-posta gönderebilirsiniz: destek@ornekapp.com'
      },
    ];

    return Scaffold(
      appBar: buildAppBar(context,"Sıkça Sorulan Sorular (SSS)"),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: faqList.length,
        itemBuilder: (context, index) {
          final faq = faqList[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
                splashColor: Colors.deepPurple.shade50,
              ),
              child: ExpansionTile(
                tilePadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                title: Text(
                  faq['question']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      faq['answer']!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
