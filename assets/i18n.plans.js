/* Hepeer Plans — dictionary (EN/TR/DE) + billing toggle & comparison table.
   Loads before assets/site.js, which consumes window.HEPEER_I18N and
   window.HEPEER_INIT. */
window.HEPEER_I18N = {
  en: {
    requestInvite: "Request an invite", bookCall: "Book a call",
    navPlatform: "Platform", navHow: "How it works", navAi: "AI", navPlans: "Plans", navAbout: "About",
    footTagline: "The next-generation digital health platform for creating, sharing and tracking AI-powered home exercise programs.",
    footProduct: "Product", footCompany: "Company", footGet: "Get started",
    footAbout: "About", footContact: "Contact us", footCareers: "Careers", footPrivacy: "Privacy", footTerms: "Terms",
    footRights: "© 2026 Hepeer · Home Exercise Programs",
    plansEyebrow: "Plans", plansTitle: "Simple plans that grow with your practice.",
    plansSub: "Start free, upgrade when you’re ready. No setup fees — your data stays 100% yours.",
    billMonthly: "Monthly", billYearly: "Yearly", billSave: "Save 20% billed yearly",
    currency: "€", perMonth: "/mo", perMonthYearly: "/mo billed yearly",
    freeName: "Free", freePrice: "Always free", freeDesc: "Everything a solo practitioner needs to get started.", freeCta: "Start free", freeIncludes: "What’s included",
    clinicName: "Clinic", clinicBadge: "Most popular", clinicDesc: "For growing practices that share without limits.", clinicCta: "Start Clinic", clinicEverything: "Everything in Free, plus",
    entName: "Enterprise", entPrice: "Custom", entDesc: "For organisations with bespoke needs.", entCta: "Contact sales", entEverything: "Everything in Clinic, plus",
    clinicMonthly: "39", clinicYearly: "31",
    fPatientInfo: "Patient information management", fBooking: "Booking & reservations with calendar", fShares5: "5 HEP shares per week", fLibrary: "Hepeer Exercise Library (incl. videos)", fUsers1: "1 user",
    fUnlimited: "Unlimited HEP creation & sharing", fTeamUsers: "Multiple team users", fPayments: "Monthly or yearly billing",
    fLicensing: "Custom-fit licensing agreement", fSupport: "Dedicated onboarding & support",
    comparisonTitle: "Compare plans", tblFeatures: "Features", priceNote: "Prices shown are placeholders — confirm your final pricing before launch.",
    plansCtaTitle: "Start free in minutes.", plansCtaSub: "Create your first HEP today and upgrade whenever your practice is ready.",
    rPatient: "Patient information management", rBooking: "Booking & calendar", rLibrary: "Exercise Library (videos)", rShares: "HEP shares", rUsers: "Users", rBilling: "Billing", rLicensing: "Licensing agreement", rSupport: "Support",
    v5week: "5 / week", vUnlimited: "Unlimited", vCustom: "Custom", v1: "1", vTeam: "Team", vFree: "Free", vMonthlyYearly: "Monthly / Yearly", vCommunity: "Community", vPriority: "Priority", vDedicated: "Dedicated", vDash: "—", vCheck: "✓"
  },
  tr: {
    requestInvite: "Davet iste", bookCall: "Görüşme planla",
    navPlatform: "Platform", navHow: "Nasıl çalışır", navAi: "Yapay zekâ", navPlans: "Planlar", navAbout: "Hakkında",
    footTagline: "Yapay zekâ destekli ev egzersiz programları oluşturmak, paylaşmak ve takip etmek için yeni nesil dijital sağlık platformu.",
    footProduct: "Ürün", footCompany: "Şirket", footGet: "Başlayın",
    footAbout: "Hakkında", footContact: "Bize ulaşın", footCareers: "Kariyer", footPrivacy: "Gizlilik", footTerms: "Koşullar",
    footRights: "© 2026 Hepeer · Ev Egzersiz Programları",
    plansEyebrow: "Planlar", plansTitle: "Muayenehanenizle birlikte büyüyen sade planlar.",
    plansSub: "Ücretsiz başlayın, hazır olduğunuzda yükseltin. Kurulum ücreti yok — verileriniz %100 size ait kalır.",
    billMonthly: "Aylık", billYearly: "Yıllık", billSave: "Yıllık ödemede %20 tasarruf",
    currency: "€", perMonth: "/ay", perMonthYearly: "/ay, yıllık faturalanır",
    freeName: "Ücretsiz", freePrice: "Her zaman ücretsiz", freeDesc: "Tek başına çalışan bir uzmanın başlamak için ihtiyacı olan her şey.", freeCta: "Ücretsiz başla", freeIncludes: "Neler dahil",
    clinicName: "Klinik", clinicBadge: "En popüler", clinicDesc: "Sınırsız paylaşan, büyüyen muayenehaneler için.", clinicCta: "Klinik’e başla", clinicEverything: "Ücretsiz’deki her şey, ayrıca",
    entName: "Kurumsal", entPrice: "Özel", entDesc: "Özel ihtiyaçları olan kuruluşlar için.", entCta: "Satışa ulaşın", entEverything: "Klinik’teki her şey, ayrıca",
    clinicMonthly: "39", clinicYearly: "31",
    fPatientInfo: "Hasta bilgi yönetimi", fBooking: "Takvimli randevu ve rezervasyon", fShares5: "Haftada 5 HEP paylaşımı", fLibrary: "Hepeer Egzersiz Kütüphanesi (videolar dahil)", fUsers1: "1 kullanıcı",
    fUnlimited: "Sınırsız HEP oluşturma ve paylaşma", fTeamUsers: "Birden fazla ekip kullanıcısı", fPayments: "Aylık veya yıllık ödeme",
    fLicensing: "Özel uyarlanmış lisans anlaşması", fSupport: "Özel kurulum ve destek",
    comparisonTitle: "Planları karşılaştırın", tblFeatures: "Özellikler", priceNote: "Gösterilen fiyatlar yer tutucudur — yayına almadan önce nihai fiyatlandırmanızı onaylayın.",
    plansCtaTitle: "Dakikalar içinde ücretsiz başlayın.", plansCtaSub: "İlk HEP’inizi bugün oluşturun, muayenehaneniz hazır olduğunda yükseltin.",
    rPatient: "Hasta bilgi yönetimi", rBooking: "Randevu ve takvim", rLibrary: "Egzersiz Kütüphanesi (video)", rShares: "HEP paylaşımı", rUsers: "Kullanıcı", rBilling: "Ödeme", rLicensing: "Lisans anlaşması", rSupport: "Destek",
    v5week: "5 / hafta", vUnlimited: "Sınırsız", vCustom: "Özel", v1: "1", vTeam: "Ekip", vFree: "Ücretsiz", vMonthlyYearly: "Aylık / Yıllık", vCommunity: "Topluluk", vPriority: "Öncelikli", vDedicated: "Özel", vDash: "—", vCheck: "✓"
  },
  de: {
    requestInvite: "Einladung anfordern", bookCall: "Termin buchen",
    navPlatform: "Plattform", navHow: "So funktioniert's", navAi: "KI", navPlans: "Tarife", navAbout: "Über uns",
    footTagline: "Die Digital-Health-Plattform der nächsten Generation zum Erstellen, Teilen und Verfolgen KI-gestützter Heimübungsprogramme.",
    footProduct: "Produkt", footCompany: "Unternehmen", footGet: "Loslegen",
    footAbout: "Über uns", footContact: "Kontakt", footCareers: "Karriere", footPrivacy: "Datenschutz", footTerms: "AGB",
    footRights: "© 2026 Hepeer · Heimübungsprogramme",
    plansEyebrow: "Tarife", plansTitle: "Einfache Tarife, die mit Ihrer Praxis wachsen.",
    plansSub: "Kostenlos starten, upgraden, wenn Sie bereit sind. Keine Einrichtungsgebühren — Ihre Daten bleiben zu 100% Ihnen.",
    billMonthly: "Monatlich", billYearly: "Jährlich", billSave: "20% sparen bei jährlicher Zahlung",
    currency: "€", perMonth: "/Mon.", perMonthYearly: "/Mon., jährlich abgerechnet",
    freeName: "Free", freePrice: "Immer kostenlos", freeDesc: "Alles, was eine Einzelpraxis für den Start braucht.", freeCta: "Kostenlos starten", freeIncludes: "Enthalten",
    clinicName: "Clinic", clinicBadge: "Am beliebtesten", clinicDesc: "Für wachsende Praxen, die ohne Limit teilen.", clinicCta: "Mit Clinic starten", clinicEverything: "Alles aus Free, plus",
    entName: "Enterprise", entPrice: "Individuell", entDesc: "Für Organisationen mit maßgeschneiderten Anforderungen.", entCta: "Vertrieb kontaktieren", entEverything: "Alles aus Clinic, plus",
    clinicMonthly: "39", clinicYearly: "31",
    fPatientInfo: "Patienten­datenverwaltung", fBooking: "Buchung & Reservierung mit Kalender", fShares5: "5 HEP-Freigaben pro Woche", fLibrary: "Hepeer Übungsbibliothek (inkl. Videos)", fUsers1: "1 Nutzer",
    fUnlimited: "Unbegrenztes Erstellen & Teilen von HEPs", fTeamUsers: "Mehrere Team-Nutzer", fPayments: "Monatliche oder jährliche Abrechnung",
    fLicensing: "Maßgeschneiderter Lizenzvertrag", fSupport: "Dediziertes Onboarding & Support",
    comparisonTitle: "Tarife vergleichen", tblFeatures: "Funktionen", priceNote: "Die angezeigten Preise sind Platzhalter — bestätigen Sie Ihre finalen Preise vor dem Launch.",
    plansCtaTitle: "In Minuten kostenlos starten.", plansCtaSub: "Erstellen Sie heute Ihren ersten HEP und upgraden Sie, wenn Ihre Praxis bereit ist.",
    rPatient: "Patientendatenverwaltung", rBooking: "Buchung & Kalender", rLibrary: "Übungsbibliothek (Videos)", rShares: "HEP-Freigaben", rUsers: "Nutzer", rBilling: "Abrechnung", rLicensing: "Lizenzvertrag", rSupport: "Support",
    v5week: "5 / Woche", vUnlimited: "Unbegrenzt", vCustom: "Individuell", v1: "1", vTeam: "Team", vFree: "Kostenlos", vMonthlyYearly: "Monatlich / Jährlich", vCommunity: "Community", vPriority: "Priorität", vDedicated: "Dediziert", vDash: "—", vCheck: "✓"
  }
};

// Comparison-table rows, mirrored from the design's renderVals().
var TABLE_ROWS = [
  { label: 'rPatient', free: 'vCheck', clinic: 'vCheck', ent: 'vCheck' },
  { label: 'rBooking', free: 'vCheck', clinic: 'vCheck', ent: 'vCheck' },
  { label: 'rLibrary', free: 'vCheck', clinic: 'vCheck', ent: 'vCheck' },
  { label: 'rShares', free: 'v5week', clinic: 'vUnlimited', ent: 'vUnlimited' },
  { label: 'rUsers', free: 'v1', clinic: 'vTeam', ent: 'vCustom' },
  { label: 'rBilling', free: 'vFree', clinic: 'vMonthlyYearly', ent: 'vCustom' },
  { label: 'rLicensing', free: 'vDash', clinic: 'vDash', ent: 'vCustom' },
  { label: 'rSupport', free: 'vCommunity', clinic: 'vPriority', ent: 'vDedicated' }
];

window.HEPEER_INIT = (window.HEPEER_INIT || []).concat(function (Hepeer) {
  var billing = 'monthly';

  // Build the comparison-table body once.
  var body = document.getElementById('compareBody');
  if (body && !body.childElementCount) {
    TABLE_ROWS.forEach(function (row) {
      var r = document.createElement('div');
      r.className = 'compare-row';
      ['label', 'free', 'clinic', 'ent'].forEach(function (col) {
        var cell = document.createElement('div');
        cell.className = col === 'label' ? 'cell-feature' : 'cell col-' + col;
        cell.setAttribute('data-i18n', row[col]);
        r.appendChild(cell);
      });
      body.appendChild(r);
    });
  }

  document.querySelectorAll('[data-billing]').forEach(function (b) {
    b.addEventListener('click', function () { billing = b.getAttribute('data-billing'); Hepeer.render(); });
  });

  // Update billing-dependent price + toggle active state on each render.
  Hepeer.onRender.push(function (t) {
    var yearly = billing === 'yearly';
    var amount = document.getElementById('clinicAmount');
    var suffix = document.getElementById('clinicSuffix');
    var save = document.getElementById('clinicSave');
    if (amount) amount.textContent = t.currency + (yearly ? t.clinicYearly : t.clinicMonthly);
    if (suffix) suffix.textContent = yearly ? t.perMonthYearly : t.perMonth;
    if (save) { save.textContent = t.billSave; save.hidden = !yearly; }
    document.querySelectorAll('[data-billing]').forEach(function (b) {
      b.classList.toggle('is-active', b.getAttribute('data-billing') === billing);
    });
  });
});
