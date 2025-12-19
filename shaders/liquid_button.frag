#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uTime;
uniform float uTilt; // -1.0 ile 1.0 arası eğim

out vec4 fragColor;

void main() {
    vec2 uv = FlutterFragCoord().xy / uSize;

    // -- FİZİK AYARLARI --
    // Eğim çarpanı: Bunu artırırsan sıvı daha çok sağa/sola yığılır
    float tiltFactor = 2.0;

    // Dalga ayarları
    float waveHeight = 0.03;
    float waveFreq = 4.0;

    // -- HESAPLAMA --
    // Eğim mantığı:
    // Telefon sağa eğilirse (uTilt pozitif), sağ taraftaki su seviyesi yükselmeli (yani y koordinatı küçülmeli, çünkü 0 yukarıda).
    // Bu formül ufuk çizgisini döndürür.
    float tiltOffset = (uv.x - 0.5) * uTilt * tiltFactor;

    // Dalgalanma (zamanla hareket eden sinüs dalgaları)
    float wave = sin(uv.x * waveFreq + uTime * 3.0) * waveHeight +
                 cos(uv.x * (waveFreq * 1.5) + uTime * 4.0) * (waveHeight * 0.5);

    // Su seviyesi eşiği (Threshold)
    // 0.5 ekranın ortasıdır. Eğim ve dalgayı buna ekliyoruz.
    float liquidLevel = 0.5 - tiltOffset + wave;

    // -- RENKLENDİRME --
    // uv.y (dikey koordinat) liquidLevel'dan büyükse orası "su"dur (Flutter'da Y aşağı artar).
    // smoothstep ile kenarları yumuşatıyoruz (anti-aliasing).
    float isLiquid = smoothstep(liquidLevel - 0.01, liquidLevel + 0.01, uv.y);

    // Renk paleti
    vec4 deepColor = vec4(0.4, 0.1, 0.8, 1.0);  // Koyu Mor
    vec4 lightColor = vec4(0.2, 0.6, 1.0, 1.0); // Açık Mavi
    vec4 foamColor = vec4(1.0, 1.0, 1.0, 0.8);  // Köpük
    vec4 emptyColor = vec4(1.0, 1.0, 1.0, 1.0); // Boş alan (Beyaz)

    // Suyun kendi içindeki gradyanı (Derinlik hissi)
    vec4 liquidFill = mix(lightColor, deepColor, (uv.y - liquidLevel) * 2.0);

    // Köpük çizgisi (Su seviyesinin hemen üzerindeki ince çizgi)
    float foamLine = smoothstep(liquidLevel - 0.04, liquidLevel - 0.01, uv.y) * (1.0 - smoothstep(liquidLevel - 0.01, liquidLevel + 0.01, uv.y));

    // Köpüğü sıvıya ekle
    vec4 finalLiquid = mix(liquidFill, foamColor, foamLine);

    // Sonuç: Boş alan mı, sıvı mı?
    fragColor = mix(emptyColor, finalLiquid, isLiquid);
}