import '../models/news_model.dart';

final List<News> newsItems = [
  News(
    id: '1',
    title: 'Yapay Zeka Eğitimde Devrim Yaratıyor',
    description: 'Yeni nesil yapay zeka araçları, öğrencilerin öğrenme deneyimlerini kişiselleştiriyor.',
    imageUrl: 'https://images.unsplash.com/photo-1677442136019-21780ecad995?w=800&q=80',
    fullContent: 'Yapay zeka teknolojileri, eğitim sektöründe büyük bir dönüşüm yaratıyor. Öğrenciler artık kendi hızlarında öğrenebiliyor ve yapay zeka destekli asistanlar sayesinde anında geri bildirim alabiliyorlar. Bu teknoloji, öğretmenlerin iş yükünü azaltırken, öğrencilere daha kişiselleştirilmiş bir öğrenme deneyimi sunuyor.\n\nUzmanlar, önümüzdeki 5 yıl içinde yapay zekanın eğitimde standart hale geleceğini öngörüyor. Özellikle adaptif öğrenme sistemleri, her öğrencinin güçlü ve zayıf yönlerini analiz ederek özel çalışma planları oluşturabiliyor.',
    publishDate: DateTime.now().subtract(const Duration(hours: 2)),
    author: 'Dr. Ayşe Yılmaz',
  ),
  News(
    id: '2',
    title: 'Online Eğitimde Yeni Dönem Başlıyor',
    description: 'Hibrit eğitim modelleri, geleneksel sınıf ortamlarıyla dijital platformları birleştiriyor.',
    imageUrl: 'https://images.unsplash.com/photo-1501504905252-473c47e087f8?w=800&q=80',
    fullContent: 'Pandemi sonrası dönemde online eğitim, kalıcı bir eğitim modeli haline geldi. Üniversiteler ve okullar, fiziksel ve dijital eğitimi birleştiren hibrit modeller geliştiriyor.\n\nBu yeni model, öğrencilere daha fazla esneklik sağlarken, eğitim kurumlarına da daha geniş bir öğrenci kitlesine ulaşma imkanı veriyor. Uzaktan eğitim teknolojileri, sanal sınıflar, canlı yayınlar ve etkileşimli içeriklerle zenginleştirilmiş durumda.',
    publishDate: DateTime.now().subtract(const Duration(hours: 5)),
    author: 'Prof. Mehmet Kaya',
  ),
  News(
    id: '3',
    title: 'Dijital Okuryazarlık Becerileri Öncelik Haline Geldi',
    description: 'Geleceğin meslekleri için dijital beceriler artık olmazsa olmaz niteliğinde.',
    imageUrl: 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=800&q=80',
    fullContent: 'Dünya Ekonomik Forumu\'nun son raporuna göre, 2030 yılına kadar iş gücünün %65\'i henüz var olmayan mesleklerde çalışacak. Bu nedenle dijital okuryazarlık ve adaptasyon becerileri kritik önem taşıyor.\n\nEğitim kurumları, müfredatlarını kodlama, veri analizi, dijital pazarlama ve siber güvenlik gibi alanlarda güçlendiriyor. Öğrenciler, teorik bilginin yanı sıra pratik dijital beceriler de kazanıyor.',
    publishDate: DateTime.now().subtract(const Duration(days: 1)),
    author: 'Zeynep Demir',
  ),
  News(
    id: '4',
    title: 'Gamification: Oyunlaştırma ile Öğrenme',
    description: 'Oyun mekanikleri eğitime entegre edilerek öğrenci motivasyonu artırılıyor.',
    imageUrl: 'https://images.unsplash.com/photo-1511512578047-dfb367046420?w=800&q=80',
    fullContent: 'Gamification, yani oyunlaştırma stratejileri, eğitim sektöründe giderek daha fazla kullanılıyor. Puanlama sistemleri, rozetler, liderlik tabloları ve görevler, öğrencilerin derse katılımını ve motivasyonunu önemli ölçüde artırıyor.\n\nAraştırmalar, oyunlaştırılmış eğitim içeriklerinin öğrenci başarısını %40\'a kadar artırabildiğini gösteriyor. Özellikle matematik ve fen bilimleri derslerinde oyunlaştırma teknikleri büyük başarı sağlıyor.',
    publishDate: DateTime.now().subtract(const Duration(days: 2)),
    author: 'Can Öztürk',
  ),
  News(
    id: '5',
    title: 'Sürdürülebilir Eğitim İçin Yeşil Kampüsler',
    description: 'Üniversiteler ve okullar çevre dostu kampüs projeleri geliştiriyor.',
    imageUrl: 'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?w=800&q=80',
    fullContent: 'İklim değişikliğiyle mücadelede eğitim kurumları öncü rol üstleniyor. Yeşil kampüs projeleri kapsamında güneş enerjisi panelleri, yağmur suyu toplama sistemleri ve sıfır atık uygulamaları hayata geçiriliyor.\n\nAyrıca, müfredatlara çevre bilinci ve sürdürülebilirlik dersleri ekleniyor. Öğrenciler, hem teorik olarak çevre konularını öğreniyor hem de kampüs uygulamalarıyla pratik deneyim kazanıyor.',
    publishDate: DateTime.now().subtract(const Duration(days: 3)),
    author: 'Elif Şahin',
  ),
];