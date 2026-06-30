-- Set line_order for all imported routes based on PDF order
-- Safe to re-run.

DO $$
DECLARE
  v_sector_id uuid;
BEGIN

  -- Petrella Liri › Petrella Alta
  SELECT s.id INTO v_sector_id
    FROM sectors s JOIN crags c ON c.id = s.crag_id
    WHERE lower(s.name) = lower('Petrella Alta')
      AND lower(c.name) = lower('Petrella Liri')
    LIMIT 1;
  IF v_sector_id IS NOT NULL THEN
    UPDATE routes SET line_order = 1
      WHERE lower(name) = lower('Senza nome 1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 2
      WHERE lower(name) = lower('Senza nome 1 var.dx') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 3
      WHERE lower(name) = lower('Antifà') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 4
      WHERE lower(name) = lower('Senza nome 2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 5
      WHERE lower(name) = lower('Senza nome 3') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 6
      WHERE lower(name) = lower('Alessio Angeloni the driller') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 7
      WHERE lower(name) = lower('Senza nome 5') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 8
      WHERE lower(name) = lower('Enigma') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 9
      WHERE lower(name) = lower('Altrobazzie') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 10
      WHERE lower(name) = lower('Senza nome 6') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 11
      WHERE lower(name) = lower('Senza nome 7') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 12
      WHERE lower(name) = lower('Senza nome 8') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 13
      WHERE lower(name) = lower('Senza nome 9') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 14
      WHERE lower(name) = lower('La teoria dei buchi neri') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 15
      WHERE lower(name) = lower('Separate reality') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 16
      WHERE lower(name) = lower('Glory hole') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 17
      WHERE lower(name) = lower('Fly Life') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 18
      WHERE lower(name) = lower('Nel nome del padre') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 19
      WHERE lower(name) = lower('Senza nome 10') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 20
      WHERE lower(name) = lower('Back to black') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 21
      WHERE lower(name) = lower('Noir desir') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 22
      WHERE lower(name) = lower('Vendee globe') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 23
      WHERE lower(name) = lower('Le donne del sud comandano e quantaltro') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 24
      WHERE lower(name) = lower('Venom (var. sx)') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 25
      WHERE lower(name) = lower('Venom') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 26
      WHERE lower(name) = lower('Osez Josephine') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 27
      WHERE lower(name) = lower('Isue de secours') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 28
      WHERE lower(name) = lower('Le casalingue') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 29
      WHERE lower(name) = lower('Modalità aereo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 30
      WHERE lower(name) = lower('Il pellecchia') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 31
      WHERE lower(name) = lower('Senza nome 11') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 32
      WHERE lower(name) = lower('Senza nome 12') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 33
      WHERE lower(name) = lower('Senza nome 13') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 34
      WHERE lower(name) = lower('Sgarbellati la testa') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 35
      WHERE lower(name) = lower('La donna col SUV') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 36
      WHERE lower(name) = lower('Dolce milù') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 37
      WHERE lower(name) = lower('Ruzza line') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 38
      WHERE lower(name) = lower('Scamandratemucho') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 39
      WHERE lower(name) = lower('Senza nome 14') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 40
      WHERE lower(name) = lower('Senza nome 15') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 41
      WHERE lower(name) = lower('La sposa cadavere') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 42
      WHERE lower(name) = lower('Robotoff') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 43
      WHERE lower(name) = lower('Dio serpente') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 44
      WHERE lower(name) = lower('Variante Dio serpente') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 45
      WHERE lower(name) = lower('Anelli di pane') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 46
      WHERE lower(name) = lower('Benvenuti a Duloc') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 47
      WHERE lower(name) = lower('La pettegola') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 48
      WHERE lower(name) = lower('Vertical') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 49
      WHERE lower(name) = lower('Besame mucho') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 50
      WHERE lower(name) = lower('Nico') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 51
      WHERE lower(name) = lower('Tina') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 52
      WHERE lower(name) = lower('Lo stratega') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 53
      WHERE lower(name) = lower('Pony express') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 54
      WHERE lower(name) = lower('Martirio') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 55
      WHERE lower(name) = lower('Spirito guida') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 56
      WHERE lower(name) = lower('Ice cube') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 57
      WHERE lower(name) = lower('Ectoplasma') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 58
      WHERE lower(name) = lower('Il mosaico di Marta') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 59
      WHERE lower(name) = lower('Made in Germany') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 60
      WHERE lower(name) = lower('Risiko') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 61
      WHERE lower(name) = lower('Gioco di Gerard') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 62
      WHERE lower(name) = lower('Volo del falco') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 63
      WHERE lower(name) = lower('Revenge') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 64
      WHERE lower(name) = lower('La fine dell''impero') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 65
      WHERE lower(name) = lower('Lullaby') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 66
      WHERE lower(name) = lower('Anakin') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 67
      WHERE lower(name) = lower('Ronchiatour direct') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 68
      WHERE lower(name) = lower('Ronchiatour') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 69
      WHERE lower(name) = lower('Trazione fatale') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 70
      WHERE lower(name) = lower('Snikefinger L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 71
      WHERE lower(name) = lower('Snikefinger L1+L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 72
      WHERE lower(name) = lower('Godiva') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 73
      WHERE lower(name) = lower('Goditela') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 74
      WHERE lower(name) = lower('Per Miriam') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 75
      WHERE lower(name) = lower('Eroi per Miriam') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 76
      WHERE lower(name) = lower('Eroi nel vento') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 77
      WHERE lower(name) = lower('Biko') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 78
      WHERE lower(name) = lower('Wish') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 79
      WHERE lower(name) = lower('Soft') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 80
      WHERE lower(name) = lower('Liberate Prometeo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 81
      WHERE lower(name) = lower('Vamonos') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 82
      WHERE lower(name) = lower('Watah') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 83
      WHERE lower(name) = lower('Feddayn') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 84
      WHERE lower(name) = lower('Tupamaros') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 85
      WHERE lower(name) = lower('Il canto della gabbianella') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 86
      WHERE lower(name) = lower('Opopomoz L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 87
      WHERE lower(name) = lower('Opopomoz L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 88
      WHERE lower(name) = lower('Linea sognata') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 89
      WHERE lower(name) = lower('La biscia che striscia nella fessura liscia') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 90
      WHERE lower(name) = lower('Senza nome 16') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 91
      WHERE lower(name) = lower('Arrivederci Skodre') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 92
      WHERE lower(name) = lower('Onda energetica') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 93
      WHERE lower(name) = lower('Alta quota') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 94
      WHERE lower(name) = lower('Edema') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 95
      WHERE lower(name) = lower('Senza nome 17') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 96
      WHERE lower(name) = lower('Regole di base') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 97
      WHERE lower(name) = lower('Sapore di Autan') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 98
      WHERE lower(name) = lower('Lupetto') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 99
      WHERE lower(name) = lower('Prima gli italiani') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 100
      WHERE lower(name) = lower('Zitto stupidó') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 101
      WHERE lower(name) = lower('Eccolo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 102
      WHERE lower(name) = lower('L''uscita del merlo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 103
      WHERE lower(name) = lower('Spacca corda') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 104
      WHERE lower(name) = lower('Senza soldi L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 105
      WHERE lower(name) = lower('Senza corda L1+L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 106
      WHERE lower(name) = lower('Roman Club') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 107
      WHERE lower(name) = lower('Ballkan club') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 108
      WHERE lower(name) = lower('Trapanato remoto') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 109
      WHERE lower(name) = lower('Temperatura ambiente') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 110
      WHERE lower(name) = lower('Old boy') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 111
      WHERE lower(name) = lower('Petrella forever') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 112
      WHERE lower(name) = lower('Kill Bill') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 113
      WHERE lower(name) = lower('Quasar') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 114
      WHERE lower(name) = lower('Coca buton') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 115
      WHERE lower(name) = lower('Aghetti') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 116
      WHERE lower(name) = lower('La banana') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 117
      WHERE lower(name) = lower('La carota') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 118
      WHERE lower(name) = lower('Il bastone') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 119
      WHERE lower(name) = lower('Massa critica') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 120
      WHERE lower(name) = lower('Takaya Todoroki') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 121
      WHERE lower(name) = lower('Lo zimbello gallico') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 122
      WHERE lower(name) = lower('A modo mio') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 123
      WHERE lower(name) = lower('Kind guide') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 124
      WHERE lower(name) = lower('Vita da spinone') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 125
      WHERE lower(name) = lower('Altezza mezza bellezza') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 126
      WHERE lower(name) = lower('Fatti i sassi tuoi') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 127
      WHERE lower(name) = lower('Sette chi?') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 128
      WHERE lower(name) = lower('Soleado') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 129
      WHERE lower(name) = lower('Battaglia di isso') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 130
      WHERE lower(name) = lower('Battaglia dei poveri') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 131
      WHERE lower(name) = lower('Che lo sforzo sia con te') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 132
      WHERE lower(name) = lower('Via le mani dal cu...ore') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 133
      WHERE lower(name) = lower('Auuu') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 134
      WHERE lower(name) = lower('Forza papà') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 135
      WHERE lower(name) = lower('Buccia di banana') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 136
      WHERE lower(name) = lower('Obiettivo qualità') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 137
      WHERE lower(name) = lower('Play climbing') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 138
      WHERE lower(name) = lower('L''abbraccio di Dafne') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 139
      WHERE lower(name) = lower('Ghost') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 140
      WHERE lower(name) = lower('Pitbull') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 141
      WHERE lower(name) = lower('Murakami') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 142
      WHERE lower(name) = lower('Li odio tutti') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 143
      WHERE lower(name) = lower('Original shit') AND sector_id = v_sector_id;
  ELSE
    RAISE WARNING 'Sector not found: % › %', 'Petrella Liri', 'Petrella Alta';
  END IF;

  -- Petrella Liri › Placche di Bini
  SELECT s.id INTO v_sector_id
    FROM sectors s JOIN crags c ON c.id = s.crag_id
    WHERE lower(s.name) = lower('Placche di Bini')
      AND lower(c.name) = lower('Petrella Liri')
    LIMIT 1;
  IF v_sector_id IS NOT NULL THEN
    UPDATE routes SET line_order = 1
      WHERE lower(name) = lower('Bob mano di fata') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 2
      WHERE lower(name) = lower('L''asino innamorato') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 3
      WHERE lower(name) = lower('Miloù') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 4
      WHERE lower(name) = lower('Grillo parlante') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 5
      WHERE lower(name) = lower('L''arca di Noè') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 6
      WHERE lower(name) = lower('Vape') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 7
      WHERE lower(name) = lower('Palle') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 8
      WHERE lower(name) = lower('Orsi marsicani') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 9
      WHERE lower(name) = lower('Il palanchino') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 10
      WHERE lower(name) = lower('Dopo il palanchino') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 11
      WHERE lower(name) = lower('Kim jong un') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 12
      WHERE lower(name) = lower('La mia nemesi') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 13
      WHERE lower(name) = lower('Taglio e cucito') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 14
      WHERE lower(name) = lower('Smog') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 15
      WHERE lower(name) = lower('Paperinox') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 16
      WHERE lower(name) = lower('Classica') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 17
      WHERE lower(name) = lower('Stefix L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 18
      WHERE lower(name) = lower('Ce sta chi ce pensa L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 19
      WHERE lower(name) = lower('Prurito') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 20
      WHERE lower(name) = lower('Silvia') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 21
      WHERE lower(name) = lower('Cuba libre') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 22
      WHERE lower(name) = lower('Mirco') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 23
      WHERE lower(name) = lower('Orione') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 24
      WHERE lower(name) = lower('Senza nome 1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 25
      WHERE lower(name) = lower('Pippicalzelunghe L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 26
      WHERE lower(name) = lower('La seconda vita di Pippi Calze Lunghe') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 27
      WHERE lower(name) = lower('Sauve-qui-peut L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 28
      WHERE lower(name) = lower('Vintage') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 29
      WHERE lower(name) = lower('Voglia di ridere') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 30
      WHERE lower(name) = lower('Voglia di rissa') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 31
      WHERE lower(name) = lower('La dieta del muco') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 32
      WHERE lower(name) = lower('Fight Club') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 33
      WHERE lower(name) = lower('Var. 69') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 34
      WHERE lower(name) = lower('Classe 74') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 35
      WHERE lower(name) = lower('Ferratelle L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 36
      WHERE lower(name) = lower('Ciambellone L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 37
      WHERE lower(name) = lower('Tiramisù L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 38
      WHERE lower(name) = lower('Babà L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 39
      WHERE lower(name) = lower('Creme caramel') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 40
      WHERE lower(name) = lower('Creps') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 41
      WHERE lower(name) = lower('Strudel L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 42
      WHERE lower(name) = lower('Strudel L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 43
      WHERE lower(name) = lower('Strudel L3') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 44
      WHERE lower(name) = lower('Rumba magica') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 45
      WHERE lower(name) = lower('Senza nome 2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 46
      WHERE lower(name) = lower('Rumba mistica') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 47
      WHERE lower(name) = lower('Senza nome 3') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 48
      WHERE lower(name) = lower('Le bateau ivre') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 49
      WHERE lower(name) = lower('Senza nome 4') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 50
      WHERE lower(name) = lower('Senza nome 5') AND sector_id = v_sector_id;
  ELSE
    RAISE WARNING 'Sector not found: % › %', 'Petrella Liri', 'Placche di Bini';
  END IF;

  -- Pietrasecca › Vena Cionca
  SELECT s.id INTO v_sector_id
    FROM sectors s JOIN crags c ON c.id = s.crag_id
    WHERE lower(s.name) = lower('Vena Cionca')
      AND lower(c.name) = lower('Pietrasecca')
    LIMIT 1;
  IF v_sector_id IS NOT NULL THEN
    UPDATE routes SET line_order = 1
      WHERE lower(name) = lower('Si puo'' fare') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 2
      WHERE lower(name) = lower('Scaramuccia') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 3
      WHERE lower(name) = lower('Safari Park') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 4
      WHERE lower(name) = lower('Senza nome 1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 5
      WHERE lower(name) = lower('Marina') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 6
      WHERE lower(name) = lower('Silvia') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 7
      WHERE lower(name) = lower('Fiore di loto') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 8
      WHERE lower(name) = lower('Senza nome 2 L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 9
      WHERE lower(name) = lower('La petit mort L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 10
      WHERE lower(name) = lower('La morte L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 11
      WHERE lower(name) = lower('Tic tac') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 12
      WHERE lower(name) = lower('Equilibri precari') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 13
      WHERE lower(name) = lower('Berhaultmania') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 14
      WHERE lower(name) = lower('Vaimo''') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 15
      WHERE lower(name) = lower('Lola Falana') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 16
      WHERE lower(name) = lower('Ordine nuovo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 17
      WHERE lower(name) = lower('Shangai') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 18
      WHERE lower(name) = lower('Polifemo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 19
      WHERE lower(name) = lower('Strapiombami sui bicipiti L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 20
      WHERE lower(name) = lower('La vita L1+L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 21
      WHERE lower(name) = lower('Calipso') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 22
      WHERE lower(name) = lower('Nemo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 23
      WHERE lower(name) = lower('Nemo uscita diretta') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 24
      WHERE lower(name) = lower('Nasce Lollo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 25
      WHERE lower(name) = lower('Eppoi Lolletto') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 26
      WHERE lower(name) = lower('Aridatece la Gioconda') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 27
      WHERE lower(name) = lower('Stretching per un nano') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 28
      WHERE lower(name) = lower('Napalm dead L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 29
      WHERE lower(name) = lower('Bouldermania') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 30
      WHERE lower(name) = lower('Jokerman') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 31
      WHERE lower(name) = lower('Rana gastrica') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 32
      WHERE lower(name) = lower('Merdacce') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 33
      WHERE lower(name) = lower('Mary L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 34
      WHERE lower(name) = lower('Caporaju L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 35
      WHERE lower(name) = lower('Le bugie hanno le gambe corte') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 36
      WHERE lower(name) = lower('Uragano') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 37
      WHERE lower(name) = lower('So ito pe stracci') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 38
      WHERE lower(name) = lower('Gemella di sinistra') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 39
      WHERE lower(name) = lower('Gemella di destra') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 40
      WHERE lower(name) = lower('Se vi va! L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 41
      WHERE lower(name) = lower('Se vi va! L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 42
      WHERE lower(name) = lower('Miriam') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 43
      WHERE lower(name) = lower('Lama non lama L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 44
      WHERE lower(name) = lower('Lama non lama L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 45
      WHERE lower(name) = lower('Lotar') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 46
      WHERE lower(name) = lower('Fasa') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 47
      WHERE lower(name) = lower('Cannolo siciliano') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 48
      WHERE lower(name) = lower('Jab') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 49
      WHERE lower(name) = lower('Eresia') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 50
      WHERE lower(name) = lower('Siddharta') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 51
      WHERE lower(name) = lower('Nick di Bari') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 52
      WHERE lower(name) = lower('La spattonata del Presidente') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 53
      WHERE lower(name) = lower('Ribelli urlanti') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 54
      WHERE lower(name) = lower('Ribelli urlanti var. dx.') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 55
      WHERE lower(name) = lower('Leaders in sindrome') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 56
      WHERE lower(name) = lower('Je vais') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 57
      WHERE lower(name) = lower('Yama') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 58
      WHERE lower(name) = lower('Eos') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 59
      WHERE lower(name) = lower('Auguri Veronica') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 60
      WHERE lower(name) = lower('Pietraseckante') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 61
      WHERE lower(name) = lower('Pontini in trasferta') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 62
      WHERE lower(name) = lower('Auto...stima') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 63
      WHERE lower(name) = lower('Appiglio prezioso') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 64
      WHERE lower(name) = lower('Classica') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 65
      WHERE lower(name) = lower('Nata al sole') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 66
      WHERE lower(name) = lower('Solengo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 67
      WHERE lower(name) = lower('La mia rovina') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 68
      WHERE lower(name) = lower('Caro Federico') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 69
      WHERE lower(name) = lower('Sembra facile L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 70
      WHERE lower(name) = lower('Placca di Danser L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 71
      WHERE lower(name) = lower('Danser in the sky L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 72
      WHERE lower(name) = lower('Service après vente') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 73
      WHERE lower(name) = lower('Il cordino di Paola') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 74
      WHERE lower(name) = lower('La mossa') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 75
      WHERE lower(name) = lower('Sotto la pioggia L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 76
      WHERE lower(name) = lower('Il volpone rampante L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 77
      WHERE lower(name) = lower('A sinistra del televisore L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 78
      WHERE lower(name) = lower('Mannaggia all''ortolano L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 79
      WHERE lower(name) = lower('I bloccati L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 80
      WHERE lower(name) = lower('Franziskaner e noccioline L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 81
      WHERE lower(name) = lower('La grande fuga') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 82
      WHERE lower(name) = lower('Rick e Tack') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 83
      WHERE lower(name) = lower('Cardo maximo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 84
      WHERE lower(name) = lower('L''anno che verrà') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 85
      WHERE lower(name) = lower('4 marzo 1943') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 86
      WHERE lower(name) = lower('Quelli che il mercoledi''...') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 87
      WHERE lower(name) = lower('La valigia di cartone') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 88
      WHERE lower(name) = lower('My architect') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 89
      WHERE lower(name) = lower('Arrivederci Moneta') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 90
      WHERE lower(name) = lower('Carbonella') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 91
      WHERE lower(name) = lower('Lo scorpione') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 92
      WHERE lower(name) = lower('Croce e delizia') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 93
      WHERE lower(name) = lower('Miss Magoo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 94
      WHERE lower(name) = lower('Pisolo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 95
      WHERE lower(name) = lower('Mammolo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 96
      WHERE lower(name) = lower('Buongiorno Pietrasecca') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 97
      WHERE lower(name) = lower('Lame rotanti') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 98
      WHERE lower(name) = lower('Lady Frittata') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 99
      WHERE lower(name) = lower('Orso merendino') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 100
      WHERE lower(name) = lower('MetaMarzo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 101
      WHERE lower(name) = lower('La smaranza') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 102
      WHERE lower(name) = lower('A destra del lampadario') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 103
      WHERE lower(name) = lower('Senza nome 3') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 104
      WHERE lower(name) = lower('Senza nome 4') AND sector_id = v_sector_id;
  ELSE
    RAISE WARNING 'Sector not found: % › %', 'Pietrasecca', 'Vena Cionca';
  END IF;

  -- Tagliacozzo › Estrema Destra
  SELECT s.id INTO v_sector_id
    FROM sectors s JOIN crags c ON c.id = s.crag_id
    WHERE lower(s.name) = lower('Estrema Destra')
      AND lower(c.name) = lower('Tagliacozzo')
    LIMIT 1;
  IF v_sector_id IS NOT NULL THEN
    UPDATE routes SET line_order = 1
      WHERE lower(name) = lower('Senza nome 4') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 2
      WHERE lower(name) = lower('Diedro naril') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 3
      WHERE lower(name) = lower('Antonello lo spiantato') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 4
      WHERE lower(name) = lower('Sbagliando t''impala') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 5
      WHERE lower(name) = lower('Serpentone') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 6
      WHERE lower(name) = lower('Acido nirvanico') AND sector_id = v_sector_id;
  ELSE
    RAISE WARNING 'Sector not found: % › %', 'Tagliacozzo', 'Estrema Destra';
  END IF;

  -- Tagliacozzo › Estrema Sinistra
  SELECT s.id INTO v_sector_id
    FROM sectors s JOIN crags c ON c.id = s.crag_id
    WHERE lower(s.name) = lower('Estrema Sinistra')
      AND lower(c.name) = lower('Tagliacozzo')
    LIMIT 1;
  IF v_sector_id IS NOT NULL THEN
    UPDATE routes SET line_order = 1
      WHERE lower(name) = lower('Vituzza') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 2
      WHERE lower(name) = lower('Pasqualina 08') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 3
      WHERE lower(name) = lower('Rossino') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 4
      WHERE lower(name) = lower('Senza nome 1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 5
      WHERE lower(name) = lower('Unita'' vinofila') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 6
      WHERE lower(name) = lower('Spigoletto') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 7
      WHERE lower(name) = lower('Camel trek') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 8
      WHERE lower(name) = lower('Senza nome 2') AND sector_id = v_sector_id;
  ELSE
    RAISE WARNING 'Sector not found: % › %', 'Tagliacozzo', 'Estrema Sinistra';
  END IF;

  -- Tagliacozzo › Grande Tetto
  SELECT s.id INTO v_sector_id
    FROM sectors s JOIN crags c ON c.id = s.crag_id
    WHERE lower(s.name) = lower('Grande Tetto')
      AND lower(c.name) = lower('Tagliacozzo')
    LIMIT 1;
  IF v_sector_id IS NOT NULL THEN
    UPDATE routes SET line_order = 1
      WHERE lower(name) = lower('Don''t eat the yellow snow') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 2
      WHERE lower(name) = lower('Dirty love') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 3
      WHERE lower(name) = lower('Equinozio') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 4
      WHERE lower(name) = lower('Ghepardi da salotto L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 5
      WHERE lower(name) = lower('Tengo ''na minchia tanta L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 6
      WHERE lower(name) = lower('Zero umiltà') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 7
      WHERE lower(name) = lower('Salto di Stagione L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 8
      WHERE lower(name) = lower('Salto di stagione L1+L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 9
      WHERE lower(name) = lower('Ballo liscio L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 10
      WHERE lower(name) = lower('Elledue L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 11
      WHERE lower(name) = lower('Buchi-Hughi') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 12
      WHERE lower(name) = lower('Toto bang') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 13
      WHERE lower(name) = lower('Il signore di Petrella') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 14
      WHERE lower(name) = lower('L''arte di giudicare') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 15
      WHERE lower(name) = lower('Torna a Surriento') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 16
      WHERE lower(name) = lower('Che spread L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 17
      WHERE lower(name) = lower('Che spread L1+L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 18
      WHERE lower(name) = lower('Il caffè di Domenico') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 19
      WHERE lower(name) = lower('Profumo di abbacchio') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 20
      WHERE lower(name) = lower('Così è la vita') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 21
      WHERE lower(name) = lower('Mòsò mandorle amare') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 22
      WHERE lower(name) = lower('Marrakesh express') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 23
      WHERE lower(name) = lower('Rosicamentos') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 24
      WHERE lower(name) = lower('Spigolando') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 25
      WHERE lower(name) = lower('Glutei in fiamme') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 26
      WHERE lower(name) = lower('Porco demonio') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 27
      WHERE lower(name) = lower('Senza nome 3') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 28
      WHERE lower(name) = lower('4 maggio') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 29
      WHERE lower(name) = lower('Il morbo di Arianna') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 30
      WHERE lower(name) = lower('La mia nuova fidanzata') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 31
      WHERE lower(name) = lower('Questione di panze') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 32
      WHERE lower(name) = lower('Ah Toto') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 33
      WHERE lower(name) = lower('Anita') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 34
      WHERE lower(name) = lower('Giulia') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 35
      WHERE lower(name) = lower('Le tre Laure') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 36
      WHERE lower(name) = lower('Beatrice') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 37
      WHERE lower(name) = lower('Alice') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 38
      WHERE lower(name) = lower('Fabiana') AND sector_id = v_sector_id;
  ELSE
    RAISE WARNING 'Sector not found: % › %', 'Tagliacozzo', 'Grande Tetto';
  END IF;

  -- Tagliacozzo › Scudo Centrale
  SELECT s.id INTO v_sector_id
    FROM sectors s JOIN crags c ON c.id = s.crag_id
    WHERE lower(s.name) = lower('Scudo Centrale')
      AND lower(c.name) = lower('Tagliacozzo')
    LIMIT 1;
  IF v_sector_id IS NOT NULL THEN
    UPDATE routes SET line_order = 1
      WHERE lower(name) = lower('Muccassassina') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 2
      WHERE lower(name) = lower('40° all''ombra') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 3
      WHERE lower(name) = lower('Bultro 71') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 4
      WHERE lower(name) = lower('Ultima chans') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 5
      WHERE lower(name) = lower('Giorgia') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 6
      WHERE lower(name) = lower('La spagnola L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 7
      WHERE lower(name) = lower('La spagnola L1+L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 8
      WHERE lower(name) = lower('Inglese') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 9
      WHERE lower(name) = lower('Distretto marsicano') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 10
      WHERE lower(name) = lower('Cazzo è finita la birra') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 11
      WHERE lower(name) = lower('A tutta birra') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 12
      WHERE lower(name) = lower('Samoano') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 13
      WHERE lower(name) = lower('Mistral') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 14
      WHERE lower(name) = lower('Miky Mouse') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 15
      WHERE lower(name) = lower('Buona la prima') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 16
      WHERE lower(name) = lower('Scassa palle') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 17
      WHERE lower(name) = lower('Jumping fox') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 18
      WHERE lower(name) = lower('Versante est') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 19
      WHERE lower(name) = lower('Vecchio chiodo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 20
      WHERE lower(name) = lower('Arihummer') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 21
      WHERE lower(name) = lower('Angelo custode') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 22
      WHERE lower(name) = lower('Ottoz') AND sector_id = v_sector_id;
  ELSE
    RAISE WARNING 'Sector not found: % › %', 'Tagliacozzo', 'Scudo Centrale';
  END IF;

  -- Caprile › Eremo
  SELECT s.id INTO v_sector_id
    FROM sectors s JOIN crags c ON c.id = s.crag_id
    WHERE lower(s.name) = lower('Eremo')
      AND lower(c.name) = lower('Caprile')
    LIMIT 1;
  IF v_sector_id IS NOT NULL THEN
    UPDATE routes SET line_order = 1
      WHERE lower(name) = lower('acCiuffaPolli') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 2
      WHERE lower(name) = lower('+Salgo+Piango') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 3
      WHERE lower(name) = lower('Zio Alx') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 4
      WHERE lower(name) = lower('Wishyouwherehere') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 5
      WHERE lower(name) = lower('Habemus nomen') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 6
      WHERE lower(name) = lower('Salsiccia') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 7
      WHERE lower(name) = lower('Ludo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 8
      WHERE lower(name) = lower('Senza nome 1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 9
      WHERE lower(name) = lower('Senza nome 2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 10
      WHERE lower(name) = lower('Senza nome 3') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 11
      WHERE lower(name) = lower('Senza nome 4') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 12
      WHERE lower(name) = lower('Senza nome 5') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 13
      WHERE lower(name) = lower('Senza nome 6') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 14
      WHERE lower(name) = lower('Senza nome 7') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 15
      WHERE lower(name) = lower('Senza nome 8') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 16
      WHERE lower(name) = lower('Senza nome 9 L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 17
      WHERE lower(name) = lower('Senza nome 9 L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 18
      WHERE lower(name) = lower('Senza nome 9 L1+L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 19
      WHERE lower(name) = lower('Senza nome 10 L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 20
      WHERE lower(name) = lower('Senza nome 10 L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 21
      WHERE lower(name) = lower('Senza nome 10 L1+L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 22
      WHERE lower(name) = lower('30 bare') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 23
      WHERE lower(name) = lower('Senza nome 11') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 24
      WHERE lower(name) = lower('Senza nome 12') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 25
      WHERE lower(name) = lower('Senza nome 13') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 26
      WHERE lower(name) = lower('La bua') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 27
      WHERE lower(name) = lower('Caprile dreaming') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 28
      WHERE lower(name) = lower('Questa non l''hai fatta Frà?') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 29
      WHERE lower(name) = lower('Lo svita miti') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 30
      WHERE lower(name) = lower('Culo (Cialis?)') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 31
      WHERE lower(name) = lower('Pancia pelosa') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 32
      WHERE lower(name) = lower('Senza nome 14') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 33
      WHERE lower(name) = lower('Fanaticaria') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 34
      WHERE lower(name) = lower('Senza nome 15') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 35
      WHERE lower(name) = lower('Oltre lo spigolo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 36
      WHERE lower(name) = lower('Senza nome 16') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 37
      WHERE lower(name) = lower('Senza nome 17') AND sector_id = v_sector_id;
  ELSE
    RAISE WARNING 'Sector not found: % › %', 'Caprile', 'Eremo';
  END IF;

  -- Caprile › I Gradoni
  SELECT s.id INTO v_sector_id
    FROM sectors s JOIN crags c ON c.id = s.crag_id
    WHERE lower(s.name) = lower('I Gradoni')
      AND lower(c.name) = lower('Caprile')
    LIMIT 1;
  IF v_sector_id IS NOT NULL THEN
    UPDATE routes SET line_order = 1
      WHERE lower(name) = lower('Senza nome 1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 2
      WHERE lower(name) = lower('Senza nome 2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 3
      WHERE lower(name) = lower('Bocca figa') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 4
      WHERE lower(name) = lower('Collaborazione') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 5
      WHERE lower(name) = lower('Superkactus') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 6
      WHERE lower(name) = lower('B-107-K') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 7
      WHERE lower(name) = lower('Tritadita') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 8
      WHERE lower(name) = lower('Lo scambista L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 9
      WHERE lower(name) = lower('Rereset L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 10
      WHERE lower(name) = lower('Anticelli L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 11
      WHERE lower(name) = lower('Il Brodo è di Gallina L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 12
      WHERE lower(name) = lower('Fiasco collection') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 13
      WHERE lower(name) = lower('Peppedek') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 14
      WHERE lower(name) = lower('Mani di forbice') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 15
      WHERE lower(name) = lower('Una volta era un bel posto') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 16
      WHERE lower(name) = lower('Mimí Cocò') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 17
      WHERE lower(name) = lower('Neutroni') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 18
      WHERE lower(name) = lower('Lucigolett') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 19
      WHERE lower(name) = lower('Quilk (Domatore di vermi)') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 20
      WHERE lower(name) = lower('Tre di gobbe') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 21
      WHERE lower(name) = lower('Tagliaspinoterapia') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 22
      WHERE lower(name) = lower('Diedro sporcaccione') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 23
      WHERE lower(name) = lower('Senza nome 3') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 24
      WHERE lower(name) = lower('Senza nome 4') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 25
      WHERE lower(name) = lower('Senza nome 5') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 26
      WHERE lower(name) = lower('Senza nome 6') AND sector_id = v_sector_id;
  ELSE
    RAISE WARNING 'Sector not found: % › %', 'Caprile', 'I Gradoni';
  END IF;

  -- Caprile › Le Canne
  SELECT s.id INTO v_sector_id
    FROM sectors s JOIN crags c ON c.id = s.crag_id
    WHERE lower(s.name) = lower('Le Canne')
      AND lower(c.name) = lower('Caprile')
    LIMIT 1;
  IF v_sector_id IS NOT NULL THEN
    UPDATE routes SET line_order = 1
      WHERE lower(name) = lower('Ma che cactus fai?') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 2
      WHERE lower(name) = lower('Califfato ciociaro') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 3
      WHERE lower(name) = lower('Senza nome 1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 4
      WHERE lower(name) = lower('Senza nome 2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 5
      WHERE lower(name) = lower('Senza nome 3') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 6
      WHERE lower(name) = lower('Senza nome 4') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 7
      WHERE lower(name) = lower('Senza nome 5') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 8
      WHERE lower(name) = lower('Stalattite nel bucone') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 9
      WHERE lower(name) = lower('Senza nome 5 bis') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 10
      WHERE lower(name) = lower('Senza nome 6') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 11
      WHERE lower(name) = lower('Senza nome 6 bis') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 12
      WHERE lower(name) = lower('Canne rosse') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 13
      WHERE lower(name) = lower('Senza nome 7') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 14
      WHERE lower(name) = lower('Senza nome 8') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 15
      WHERE lower(name) = lower('Senza nome 9') AND sector_id = v_sector_id;
  ELSE
    RAISE WARNING 'Sector not found: % › %', 'Caprile', 'Le Canne';
  END IF;

  -- Caprile › Le Grandi Panze
  SELECT s.id INTO v_sector_id
    FROM sectors s JOIN crags c ON c.id = s.crag_id
    WHERE lower(s.name) = lower('Le Grandi Panze')
      AND lower(c.name) = lower('Caprile')
    LIMIT 1;
  IF v_sector_id IS NOT NULL THEN
    UPDATE routes SET line_order = 1
      WHERE lower(name) = lower('Senza nome 1 L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 2
      WHERE lower(name) = lower('Senza nome 1 L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 3
      WHERE lower(name) = lower('Senza nome 2 L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 4
      WHERE lower(name) = lower('Senza nome 2 L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 5
      WHERE lower(name) = lower('Job') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 6
      WHERE lower(name) = lower('La biomeccanica') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 7
      WHERE lower(name) = lower('Cioppi Cioppi') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 8
      WHERE lower(name) = lower('Senza nome 3') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 9
      WHERE lower(name) = lower('Senza nome 4') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 10
      WHERE lower(name) = lower('Acido lattico') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 11
      WHERE lower(name) = lower('Centerbe') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 12
      WHERE lower(name) = lower('Sesto acuto') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 13
      WHERE lower(name) = lower('Cirrosi sciatica') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 14
      WHERE lower(name) = lower('Giovanna d''Arco') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 15
      WHERE lower(name) = lower('Senza nome 5') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 16
      WHERE lower(name) = lower('Buccia d''arancia') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 17
      WHERE lower(name) = lower('La pececa L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 18
      WHERE lower(name) = lower('Centocimici L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 19
      WHERE lower(name) = lower('Senza nome 6') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 20
      WHERE lower(name) = lower('Senza nome 7') AND sector_id = v_sector_id;
  ELSE
    RAISE WARNING 'Sector not found: % › %', 'Caprile', 'Le Grandi Panze';
  END IF;

  -- Collepardo › Cueva
  SELECT s.id INTO v_sector_id
    FROM sectors s JOIN crags c ON c.id = s.crag_id
    WHERE lower(s.name) = lower('Cueva')
      AND lower(c.name) = lower('Collepardo')
    LIMIT 1;
  IF v_sector_id IS NOT NULL THEN
    UPDATE routes SET line_order = 1
      WHERE lower(name) = lower('Traverso della muerte L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 2
      WHERE lower(name) = lower('Traverso della muerte L1+L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 3
      WHERE lower(name) = lower('Traverso dei sogni') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 4
      WHERE lower(name) = lower('Reveille-toi') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 5
      WHERE lower(name) = lower('Tomorrowland L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 6
      WHERE lower(name) = lower('La terra dei sogni L1+L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 7
      WHERE lower(name) = lower('Tomorrowland extension L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 8
      WHERE lower(name) = lower('Tomorrowland extension L1+L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 9
      WHERE lower(name) = lower('Bella Lù L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 10
      WHERE lower(name) = lower('Bella Lù L1+L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 11
      WHERE lower(name) = lower('Clorophilla L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 12
      WHERE lower(name) = lower('Clorophilla L1+L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 13
      WHERE lower(name) = lower('Donkey kong') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 14
      WHERE lower(name) = lower('L''assassino L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 15
      WHERE lower(name) = lower('L''assassino L1+L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 16
      WHERE lower(name) = lower('Il ritorno') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 17
      WHERE lower(name) = lower('Sadomasoclimb L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 18
      WHERE lower(name) = lower('Sadomasoclimb L1+L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 19
      WHERE lower(name) = lower('Madonnazinonvedol''ora') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 20
      WHERE lower(name) = lower('Spermatocanna') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 21
      WHERE lower(name) = lower('L''anno mio') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 22
      WHERE lower(name) = lower('Abbasso la pinna') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 23
      WHERE lower(name) = lower('Cresta di gallo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 24
      WHERE lower(name) = lower('Torno subito') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 25
      WHERE lower(name) = lower('Super Crack') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 26
      WHERE lower(name) = lower('Piccola Giulia') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 27
      WHERE lower(name) = lower('La gasparata L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 28
      WHERE lower(name) = lower('La gasparata L1+L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 29
      WHERE lower(name) = lower('95 bpm') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 30
      WHERE lower(name) = lower('La spada Jedy L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 31
      WHERE lower(name) = lower('Yuri Gagarin L1+L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 32
      WHERE lower(name) = lower('I sette passi') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 33
      WHERE lower(name) = lower('Fuckaldo L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 34
      WHERE lower(name) = lower('Ma non vuoi o non puoi? L1+L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 35
      WHERE lower(name) = lower('Vertical Park L1+L2+L3') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 36
      WHERE lower(name) = lower('Eye of the tiger') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 37
      WHERE lower(name) = lower('One peace') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 38
      WHERE lower(name) = lower('3:36') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 39
      WHERE lower(name) = lower('Se non ci penso io...') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 40
      WHERE lower(name) = lower('La scallona') AND sector_id = v_sector_id;
  ELSE
    RAISE WARNING 'Sector not found: % › %', 'Collepardo', 'Cueva';
  END IF;

  -- Collepardo › Cuevita
  SELECT s.id INTO v_sector_id
    FROM sectors s JOIN crags c ON c.id = s.crag_id
    WHERE lower(s.name) = lower('Cuevita')
      AND lower(c.name) = lower('Collepardo')
    LIMIT 1;
  IF v_sector_id IS NOT NULL THEN
    UPDATE routes SET line_order = 1
      WHERE lower(name) = lower('Come piace a me') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 2
      WHERE lower(name) = lower('Felix') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 3
      WHERE lower(name) = lower('Riabassa la pinna') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 4
      WHERE lower(name) = lower('50/50') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 5
      WHERE lower(name) = lower('Super santos') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 6
      WHERE lower(name) = lower('Sono finiti gli anni 80') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 7
      WHERE lower(name) = lower('Mister laghetto') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 8
      WHERE lower(name) = lower('Senza nome 1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 9
      WHERE lower(name) = lower('L''incompresa') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 10
      WHERE lower(name) = lower('Zio Domenico') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 11
      WHERE lower(name) = lower('Old skull') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 12
      WHERE lower(name) = lower('Nero a metà') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 13
      WHERE lower(name) = lower('Il bullo, il manesco e l''autistico') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 14
      WHERE lower(name) = lower('Vertical family') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 15
      WHERE lower(name) = lower('Senza nome 2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 16
      WHERE lower(name) = lower('Merda de vacca') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 17
      WHERE lower(name) = lower('Senza nome 3') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 18
      WHERE lower(name) = lower('Il nero sfinisce') AND sector_id = v_sector_id;
  ELSE
    RAISE WARNING 'Sector not found: % › %', 'Collepardo', 'Cuevita';
  END IF;

  -- Norma › Placche Rosse
  SELECT s.id INTO v_sector_id
    FROM sectors s JOIN crags c ON c.id = s.crag_id
    WHERE lower(s.name) = lower('Placche Rosse')
      AND lower(c.name) = lower('Norma')
    LIMIT 1;
  IF v_sector_id IS NOT NULL THEN
    UPDATE routes SET line_order = 1
      WHERE lower(name) = lower('Hard lisc') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 2
      WHERE lower(name) = lower('Melanio') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 3
      WHERE lower(name) = lower('Drakulesco') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 4
      WHERE lower(name) = lower('Salsa') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 5
      WHERE lower(name) = lower('Merengue') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 6
      WHERE lower(name) = lower('Eroe del silenzio') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 7
      WHERE lower(name) = lower('May day') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 8
      WHERE lower(name) = lower('Iron man') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 9
      WHERE lower(name) = lower('Tossicomane') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 10
      WHERE lower(name) = lower('Jump') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 11
      WHERE lower(name) = lower('Gabibbo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 12
      WHERE lower(name) = lower('Cagliostro') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 13
      WHERE lower(name) = lower('Demolition girl') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 14
      WHERE lower(name) = lower('Bunny e Clik') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 15
      WHERE lower(name) = lower('Tex') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 16
      WHERE lower(name) = lower('Pretty woman') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 17
      WHERE lower(name) = lower('Lecca lecca') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 18
      WHERE lower(name) = lower('Patriots') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 19
      WHERE lower(name) = lower('Demolition man') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 20
      WHERE lower(name) = lower('Cavalier tempesta') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 21
      WHERE lower(name) = lower('Macchia nera') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 22
      WHERE lower(name) = lower('Venti dell''est') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 23
      WHERE lower(name) = lower('Biberon') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 24
      WHERE lower(name) = lower('Il pensionato') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 25
      WHERE lower(name) = lower('La valle dell''eco') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 26
      WHERE lower(name) = lower('La clava') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 27
      WHERE lower(name) = lower('Electric people') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 28
      WHERE lower(name) = lower('Aftherglow') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 29
      WHERE lower(name) = lower('La tana del geco') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 30
      WHERE lower(name) = lower('El perma') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 31
      WHERE lower(name) = lower('Tempo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 32
      WHERE lower(name) = lower('Variante tempo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 33
      WHERE lower(name) = lower('Pioggia di luce') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 34
      WHERE lower(name) = lower('Trippegghi e Climborazzo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 35
      WHERE lower(name) = lower('Belfagor') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 36
      WHERE lower(name) = lower('Scusate i ritardi') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 37
      WHERE lower(name) = lower('Over and over') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 38
      WHERE lower(name) = lower('One undred degrace') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 39
      WHERE lower(name) = lower('Licantropia') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 40
      WHERE lower(name) = lower('Cocktail di scarpe') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 41
      WHERE lower(name) = lower('Il ruggito del laicone') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 42
      WHERE lower(name) = lower('Piange il telefonino') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 43
      WHERE lower(name) = lower('Trapanetor') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 44
      WHERE lower(name) = lower('Grande Allok') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 45
      WHERE lower(name) = lower('Geremia') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 46
      WHERE lower(name) = lower('Via tutta mia') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 47
      WHERE lower(name) = lower('Little frog') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 48
      WHERE lower(name) = lower('Little frog diretta') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 49
      WHERE lower(name) = lower('Come un lupo nella notte') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 50
      WHERE lower(name) = lower('Strapiombetti') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 51
      WHERE lower(name) = lower('Diedro rosso') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 52
      WHERE lower(name) = lower('Spigolo del cactus') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 53
      WHERE lower(name) = lower('Diedro di Roberto') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 54
      WHERE lower(name) = lower('Betty blue') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 55
      WHERE lower(name) = lower('Tracchiellozza') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 56
      WHERE lower(name) = lower('Strapazzami') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 57
      WHERE lower(name) = lower('Saponette') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 58
      WHERE lower(name) = lower('Sandrokan e i pigrotti della falesia') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 59
      WHERE lower(name) = lower('Variante') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 60
      WHERE lower(name) = lower('Infrasettimanale') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 61
      WHERE lower(name) = lower('Giovani rampolli') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 62
      WHERE lower(name) = lower('Dolores de panza') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 63
      WHERE lower(name) = lower('La pera') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 64
      WHERE lower(name) = lower('Festa di compleanno') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 65
      WHERE lower(name) = lower('Nessuno è perfetto') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 66
      WHERE lower(name) = lower('C.C.C.P.') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 67
      WHERE lower(name) = lower('Perchè no?') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 68
      WHERE lower(name) = lower('Scout') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 69
      WHERE lower(name) = lower('Non mas') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 70
      WHERE lower(name) = lower('Spigolo del congedo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 71
      WHERE lower(name) = lower('Fess...urrà') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 72
      WHERE lower(name) = lower('Moda') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 73
      WHERE lower(name) = lower('Senza nome 1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 74
      WHERE lower(name) = lower('Sulmo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 75
      WHERE lower(name) = lower('L''albero nero') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 76
      WHERE lower(name) = lower('Ursus') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 77
      WHERE lower(name) = lower('Lobotomy') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 78
      WHERE lower(name) = lower('La puzzola') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 79
      WHERE lower(name) = lower('Il ritorno del barman') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 80
      WHERE lower(name) = lower('Space man') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 81
      WHERE lower(name) = lower('Amadeus') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 82
      WHERE lower(name) = lower('Nano nano') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 83
      WHERE lower(name) = lower('C''est la vie') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 84
      WHERE lower(name) = lower('Regina della pioggia') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 85
      WHERE lower(name) = lower('No me siento') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 86
      WHERE lower(name) = lower('Time out') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 87
      WHERE lower(name) = lower('Il fachiro') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 88
      WHERE lower(name) = lower('Fico d''India') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 89
      WHERE lower(name) = lower('Rigel') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 90
      WHERE lower(name) = lower('Mò so cazzi') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 91
      WHERE lower(name) = lower('Perone') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 92
      WHERE lower(name) = lower('Melone') AND sector_id = v_sector_id;
  ELSE
    RAISE WARNING 'Sector not found: % › %', 'Norma', 'Placche Rosse';
  END IF;

  -- Configni › Placca Rossa
  SELECT s.id INTO v_sector_id
    FROM sectors s JOIN crags c ON c.id = s.crag_id
    WHERE lower(s.name) = lower('Placca Rossa')
      AND lower(c.name) = lower('Configni')
    LIMIT 1;
  IF v_sector_id IS NOT NULL THEN
    UPDATE routes SET line_order = 1
      WHERE lower(name) = lower('Rinascita di Configni') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 2
      WHERE lower(name) = lower('Ai Configni della Realtà') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 3
      WHERE lower(name) = lower('I confini di Configni') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 4
      WHERE lower(name) = lower('Wang') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 5
      WHERE lower(name) = lower('Magica bula') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 6
      WHERE lower(name) = lower('I tozzetti di Anna') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 7
      WHERE lower(name) = lower('Il calderone celtico') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 8
      WHERE lower(name) = lower('Leo Tre Caffè') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 9
      WHERE lower(name) = lower('Shamshi') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 10
      WHERE lower(name) = lower('Litodomi') AND sector_id = v_sector_id;
  ELSE
    RAISE WARNING 'Sector not found: % › %', 'Configni', 'Placca Rossa';
  END IF;

  -- Configni › Settore A
  SELECT s.id INTO v_sector_id
    FROM sectors s JOIN crags c ON c.id = s.crag_id
    WHERE lower(s.name) = lower('Settore A')
      AND lower(c.name) = lower('Configni')
    LIMIT 1;
  IF v_sector_id IS NOT NULL THEN
    UPDATE routes SET line_order = 1
      WHERE lower(name) = lower('Cip') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 2
      WHERE lower(name) = lower('Ciop') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 3
      WHERE lower(name) = lower('The Eye') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 4
      WHERE lower(name) = lower('1998') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 5
      WHERE lower(name) = lower('Tettino') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 6
      WHERE lower(name) = lower('Arianna') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 7
      WHERE lower(name) = lower('Ale') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 8
      WHERE lower(name) = lower('Brick') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 9
      WHERE lower(name) = lower('Rino') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 10
      WHERE lower(name) = lower('Il Sole') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 11
      WHERE lower(name) = lower('Hot jazz') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 12
      WHERE lower(name) = lower('Hard rock') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 13
      WHERE lower(name) = lower('Zoom') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 14
      WHERE lower(name) = lower('Grazie Mario') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 15
      WHERE lower(name) = lower('Alfio') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 16
      WHERE lower(name) = lower('Bye bye baby') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 17
      WHERE lower(name) = lower('Tribolazione') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 18
      WHERE lower(name) = lower('Concoraggio') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 19
      WHERE lower(name) = lower('Disturbata') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 20
      WHERE lower(name) = lower('Slittony') AND sector_id = v_sector_id;
  ELSE
    RAISE WARNING 'Sector not found: % › %', 'Configni', 'Settore A';
  END IF;

  -- Configni › Settore B
  SELECT s.id INTO v_sector_id
    FROM sectors s JOIN crags c ON c.id = s.crag_id
    WHERE lower(s.name) = lower('Settore B')
      AND lower(c.name) = lower('Configni')
    LIMIT 1;
  IF v_sector_id IS NOT NULL THEN
    UPDATE routes SET line_order = 1
      WHERE lower(name) = lower('Paperino') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 2
      WHERE lower(name) = lower('Qui') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 3
      WHERE lower(name) = lower('Quo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 4
      WHERE lower(name) = lower('Qua') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 5
      WHERE lower(name) = lower('Paperoga') AND sector_id = v_sector_id;
  ELSE
    RAISE WARNING 'Sector not found: % › %', 'Configni', 'Settore B';
  END IF;

  -- Configni › Settore C
  SELECT s.id INTO v_sector_id
    FROM sectors s JOIN crags c ON c.id = s.crag_id
    WHERE lower(s.name) = lower('Settore C')
      AND lower(c.name) = lower('Configni')
    LIMIT 1;
  IF v_sector_id IS NOT NULL THEN
    UPDATE routes SET line_order = 1
      WHERE lower(name) = lower('Hagrid') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 2
      WHERE lower(name) = lower('Califano') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 3
      WHERE lower(name) = lower('Variante sx Il pilastrino') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 4
      WHERE lower(name) = lower('Pilastrino') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 5
      WHERE lower(name) = lower('Jambo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 6
      WHERE lower(name) = lower('L''urlo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 7
      WHERE lower(name) = lower('Cetlen') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 8
      WHERE lower(name) = lower('Le du socere') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 9
      WHERE lower(name) = lower('Ra L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 10
      WHERE lower(name) = lower('Ra L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 11
      WHERE lower(name) = lower('3m') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 12
      WHERE lower(name) = lower('Xiatien L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 13
      WHERE lower(name) = lower('Xiatien L2') AND sector_id = v_sector_id;
  ELSE
    RAISE WARNING 'Sector not found: % › %', 'Configni', 'Settore C';
  END IF;

  -- Configni › Settore D
  SELECT s.id INTO v_sector_id
    FROM sectors s JOIN crags c ON c.id = s.crag_id
    WHERE lower(s.name) = lower('Settore D')
      AND lower(c.name) = lower('Configni')
    LIMIT 1;
  IF v_sector_id IS NOT NULL THEN
    UPDATE routes SET line_order = 1
      WHERE lower(name) = lower('La giostra di Zazza') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 2
      WHERE lower(name) = lower('Mi faccio il riccio') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 3
      WHERE lower(name) = lower('E adesso basta') AND sector_id = v_sector_id;
  ELSE
    RAISE WARNING 'Sector not found: % › %', 'Configni', 'Settore D';
  END IF;

  -- Configni › Settore E
  SELECT s.id INTO v_sector_id
    FROM sectors s JOIN crags c ON c.id = s.crag_id
    WHERE lower(s.name) = lower('Settore E')
      AND lower(c.name) = lower('Configni')
    LIMIT 1;
  IF v_sector_id IS NOT NULL THEN
    UPDATE routes SET line_order = 1
      WHERE lower(name) = lower('Gli accimatori') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 2
      WHERE lower(name) = lower('Il tappezziere ingiallito') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 3
      WHERE lower(name) = lower('L''isola di Configni') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 4
      WHERE lower(name) = lower('La palma di Configni') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 5
      WHERE lower(name) = lower('Piccoli passi') AND sector_id = v_sector_id;
  ELSE
    RAISE WARNING 'Sector not found: % › %', 'Configni', 'Settore E';
  END IF;

  -- Configni › Settore F
  SELECT s.id INTO v_sector_id
    FROM sectors s JOIN crags c ON c.id = s.crag_id
    WHERE lower(s.name) = lower('Settore F')
      AND lower(c.name) = lower('Configni')
    LIMIT 1;
  IF v_sector_id IS NOT NULL THEN
    UPDATE routes SET line_order = 1
      WHERE lower(name) = lower('Configni a 360') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 2
      WHERE lower(name) = lower('Il prugnolo') AND sector_id = v_sector_id;
  ELSE
    RAISE WARNING 'Sector not found: % › %', 'Configni', 'Settore F';
  END IF;

  -- Grotti › Grotti Bassa - Nuovo Settore
  SELECT s.id INTO v_sector_id
    FROM sectors s JOIN crags c ON c.id = s.crag_id
    WHERE lower(s.name) = lower('Grotti Bassa - Nuovo Settore')
      AND lower(c.name) = lower('Grotti')
    LIMIT 1;
  IF v_sector_id IS NOT NULL THEN
    UPDATE routes SET line_order = 1
      WHERE lower(name) = lower('Ferite') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 2
      WHERE lower(name) = lower('Tagli') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 3
      WHERE lower(name) = lower('Contusioni') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 4
      WHERE lower(name) = lower('Il vena') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 5
      WHERE lower(name) = lower('Batman') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 6
      WHERE lower(name) = lower('L''ombra del bastone') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 7
      WHERE lower(name) = lower('Il mollicone') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 8
      WHERE lower(name) = lower('Mago supremo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 9
      WHERE lower(name) = lower('La froceria') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 10
      WHERE lower(name) = lower('Le return de Frank') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 11
      WHERE lower(name) = lower('Zio Gianguido') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 12
      WHERE lower(name) = lower('A piede libero') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 13
      WHERE lower(name) = lower('Alfredo Alfredo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 14
      WHERE lower(name) = lower('Paura') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 15
      WHERE lower(name) = lower('Labinia') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 16
      WHERE lower(name) = lower('Mission') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 17
      WHERE lower(name) = lower('Valla a falla') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 18
      WHERE lower(name) = lower('Allegria') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 19
      WHERE lower(name) = lower('Scaccolone') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 20
      WHERE lower(name) = lower('Gli invidiosi') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 21
      WHERE lower(name) = lower('S.O.S') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 22
      WHERE lower(name) = lower('Il Pippone') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 23
      WHERE lower(name) = lower('Ritornerai') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 24
      WHERE lower(name) = lower('Il Droga') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 25
      WHERE lower(name) = lower('Che schifo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 26
      WHERE lower(name) = lower('Rosa sativa') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 27
      WHERE lower(name) = lower('Ritorno') AND sector_id = v_sector_id;
  ELSE
    RAISE WARNING 'Sector not found: % › %', 'Grotti', 'Grotti Bassa - Nuovo Settore';
  END IF;

  -- La Fortezza › La Fortezza
  SELECT s.id INTO v_sector_id
    FROM sectors s JOIN crags c ON c.id = s.crag_id
    WHERE lower(s.name) = lower('La Fortezza')
      AND lower(c.name) = lower('La Fortezza')
    LIMIT 1;
  IF v_sector_id IS NOT NULL THEN
    UPDATE routes SET line_order = 1
      WHERE lower(name) = lower('Avanguardia') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 2
      WHERE lower(name) = lower('La Giggiata') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 3
      WHERE lower(name) = lower('Cos''è facile') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 4
      WHERE lower(name) = lower('Piramid') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 5
      WHERE lower(name) = lower('La normale') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 6
      WHERE lower(name) = lower('...abu') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 7
      WHERE lower(name) = lower('BaaB L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 8
      WHERE lower(name) = lower('BaaB L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 9
      WHERE lower(name) = lower('Zahma') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 10
      WHERE lower(name) = lower('Albedo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 11
      WHERE lower(name) = lower('Nigredo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 12
      WHERE lower(name) = lower('La prostata') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 13
      WHERE lower(name) = lower('The little flower') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 14
      WHERE lower(name) = lower('Cucciolo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 15
      WHERE lower(name) = lower('La valle del 2000') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 16
      WHERE lower(name) = lower('Sogno Lucido') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 17
      WHERE lower(name) = lower('Observe') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 18
      WHERE lower(name) = lower('Senza nome 1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 19
      WHERE lower(name) = lower('Attrazione') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 20
      WHERE lower(name) = lower('Jumpe') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 21
      WHERE lower(name) = lower('Ascoltati') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 22
      WHERE lower(name) = lower('Fuori dai pendoli') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 23
      WHERE lower(name) = lower('So what') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 24
      WHERE lower(name) = lower('Calvi Klimb') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 25
      WHERE lower(name) = lower('37 secondi') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 26
      WHERE lower(name) = lower('Mente') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 27
      WHERE lower(name) = lower('Corpo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 28
      WHERE lower(name) = lower('Maya') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 29
      WHERE lower(name) = lower('Grazie') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 30
      WHERE lower(name) = lower('Inerzia') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 31
      WHERE lower(name) = lower('Idiocrazia') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 32
      WHERE lower(name) = lower('The bra') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 33
      WHERE lower(name) = lower('The get down') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 34
      WHERE lower(name) = lower('White rabbit') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 35
      WHERE lower(name) = lower('RCC') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 36
      WHERE lower(name) = lower('Ipocrisia') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 37
      WHERE lower(name) = lower('Senza nome 2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 38
      WHERE lower(name) = lower('Dopo dopo pure tu') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 39
      WHERE lower(name) = lower('Cagliostro') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 40
      WHERE lower(name) = lower('Deleta resurgo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 41
      WHERE lower(name) = lower('Quantico') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 42
      WHERE lower(name) = lower('Lo specchio') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 43
      WHERE lower(name) = lower('Tutimenti') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 44
      WHERE lower(name) = lower('Sinfonia d''autunno') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 45
      WHERE lower(name) = lower('Adamo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 46
      WHERE lower(name) = lower('Schizzechea with love') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 47
      WHERE lower(name) = lower('Senza nome 3') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 48
      WHERE lower(name) = lower('Esegesi') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 49
      WHERE lower(name) = lower('Il frutto della conoscenza') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 50
      WHERE lower(name) = lower('Le scelte') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 51
      WHERE lower(name) = lower('Negli occhi') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 52
      WHERE lower(name) = lower('Tune up') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 53
      WHERE lower(name) = lower('Bitches brew') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 54
      WHERE lower(name) = lower('Alertez les bébés') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 55
      WHERE lower(name) = lower('Cyborg, metà uomo e metà bidito artificiale') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 56
      WHERE lower(name) = lower('Ghost in the Shell') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 57
      WHERE lower(name) = lower('Aia') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 58
      WHERE lower(name) = lower('Thor') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 59
      WHERE lower(name) = lower('Tengo Famiglia') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 60
      WHERE lower(name) = lower('Come mi pare') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 61
      WHERE lower(name) = lower('Io posso entrare') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 62
      WHERE lower(name) = lower('Meritocrazia') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 63
      WHERE lower(name) = lower('La montagna è cultura') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 64
      WHERE lower(name) = lower('Medioman') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 65
      WHERE lower(name) = lower('Tangente') AND sector_id = v_sector_id;
  ELSE
    RAISE WARNING 'Sector not found: % › %', 'La Fortezza', 'La Fortezza';
  END IF;

  -- Ripa Majala › Settore Principale
  SELECT s.id INTO v_sector_id
    FROM sectors s JOIN crags c ON c.id = s.crag_id
    WHERE lower(s.name) = lower('Settore Principale')
      AND lower(c.name) = lower('Ripa Majala')
    LIMIT 1;
  IF v_sector_id IS NOT NULL THEN
    UPDATE routes SET line_order = 1
      WHERE lower(name) = lower('Mastica zi') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 2
      WHERE lower(name) = lower('Alta marea') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 3
      WHERE lower(name) = lower('Gioia e rivoluzione') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 4
      WHERE lower(name) = lower('Mamma li turchi') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 5
      WHERE lower(name) = lower('Senza nome 1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 6
      WHERE lower(name) = lower('Acqua azzurra') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 7
      WHERE lower(name) = lower('Maremma maiala') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 8
      WHERE lower(name) = lower('Passalento') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 9
      WHERE lower(name) = lower('San soufflè') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 10
      WHERE lower(name) = lower('Passaveloce') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 11
      WHERE lower(name) = lower('La pallina di Lina') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 12
      WHERE lower(name) = lower('Variante de Alla larga i farisei') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 13
      WHERE lower(name) = lower('Alla larga i farisei') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 14
      WHERE lower(name) = lower('Polemika') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 15
      WHERE lower(name) = lower('Ore perse') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 16
      WHERE lower(name) = lower('Civitavecchia verticale') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 17
      WHERE lower(name) = lower('Il raglio del somaro') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 18
      WHERE lower(name) = lower('Necrosi muscolare') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 19
      WHERE lower(name) = lower('Lo scudo di Avalon') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 20
      WHERE lower(name) = lower('DiscantoMediterraneo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 21
      WHERE lower(name) = lower('Mediterranea L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 22
      WHERE lower(name) = lower('Mediterranea L1 + L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 23
      WHERE lower(name) = lower('Falce e martello') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 24
      WHERE lower(name) = lower('Potere operaio') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 25
      WHERE lower(name) = lower('Lotta continua L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 26
      WHERE lower(name) = lower('Lotta continua L1+L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 27
      WHERE lower(name) = lower('Sinistra antagonista') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 28
      WHERE lower(name) = lower('Siegfried L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 29
      WHERE lower(name) = lower('Siegfried L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 30
      WHERE lower(name) = lower('Morte all''imperialismo mondiale') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 31
      WHERE lower(name) = lower('L''ora d''aria') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 32
      WHERE lower(name) = lower('Solo per gente di mare') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 33
      WHERE lower(name) = lower('Nonno santo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 34
      WHERE lower(name) = lower('Legalizzatela L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 35
      WHERE lower(name) = lower('Var. Dose media giornaliera') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 36
      WHERE lower(name) = lower('Dose media giornaliera L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 37
      WHERE lower(name) = lower('Dose media giornaliera L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 38
      WHERE lower(name) = lower('Coffee break') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 39
      WHERE lower(name) = lower('Variante tossica') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 40
      WHERE lower(name) = lower('Modica quantità L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 41
      WHERE lower(name) = lower('Il velo di Maia L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 42
      WHERE lower(name) = lower('Brilligiù L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 43
      WHERE lower(name) = lower('Wadi Rum L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 44
      WHERE lower(name) = lower('La dama del lago L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 45
      WHERE lower(name) = lower('Metropolis L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 46
      WHERE lower(name) = lower('Mezza sega L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 47
      WHERE lower(name) = lower('Gola profonda L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 48
      WHERE lower(name) = lower('Istigazione a delinquere L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 49
      WHERE lower(name) = lower('La pagherete cara la pagherete tutti L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 50
      WHERE lower(name) = lower('Io sono il vento L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 51
      WHERE lower(name) = lower('Microcriminalità') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 52
      WHERE lower(name) = lower('Ca z o') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 53
      WHERE lower(name) = lower('Boh!') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 54
      WHERE lower(name) = lower('Se la conosci la eviti') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 55
      WHERE lower(name) = lower('Fax totum') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 56
      WHERE lower(name) = lower('Fra la via Aurelia ed il West') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 57
      WHERE lower(name) = lower('Mezza sega') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 58
      WHERE lower(name) = lower('Re.Le.') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 59
      WHERE lower(name) = lower('Foxtrot') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 60
      WHERE lower(name) = lower('Lo zighero') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 61
      WHERE lower(name) = lower('La Ciociara volante') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 62
      WHERE lower(name) = lower('La Cia ci spia') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 63
      WHERE lower(name) = lower('La zighera L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 64
      WHERE lower(name) = lower('La zighera L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 65
      WHERE lower(name) = lower('Eskimo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 66
      WHERE lower(name) = lower('Il migliore') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 67
      WHERE lower(name) = lower('Dolores de panzas') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 68
      WHERE lower(name) = lower('Manipolazione genetica') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 69
      WHERE lower(name) = lower('Porci con le ali') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 70
      WHERE lower(name) = lower('Amico fragile') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 71
      WHERE lower(name) = lower('Maiale incontinente') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 72
      WHERE lower(name) = lower('La normale') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 73
      WHERE lower(name) = lower('Diavoli al culo L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 74
      WHERE lower(name) = lower('La spinosa') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 75
      WHERE lower(name) = lower('Variante La spinosa') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 76
      WHERE lower(name) = lower('Vitto e alloggio') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 77
      WHERE lower(name) = lower('Soviet supremo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 78
      WHERE lower(name) = lower('Comitato centrale') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 79
      WHERE lower(name) = lower('G.A.C.') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 80
      WHERE lower(name) = lower('Hermes') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 81
      WHERE lower(name) = lower('Ostpolitk') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 82
      WHERE lower(name) = lower('Ostpolitik variante dx') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 83
      WHERE lower(name) = lower('Ripa libera') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 84
      WHERE lower(name) = lower('Socialismo reale') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 85
      WHERE lower(name) = lower('La lunga marcia') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 86
      WHERE lower(name) = lower('Pista Ho Chi Minh') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 87
      WHERE lower(name) = lower('Il baratro L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 88
      WHERE lower(name) = lower('Il rosso e il nero L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 89
      WHERE lower(name) = lower('Tg 0 L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 90
      WHERE lower(name) = lower('Samarcanda L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 91
      WHERE lower(name) = lower('Truffa truffa ambiguità L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 92
      WHERE lower(name) = lower('Mi manda Lubrano L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 93
      WHERE lower(name) = lower('Cazzarola L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 94
      WHERE lower(name) = lower('Sole nero L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 95
      WHERE lower(name) = lower('Rapsodia in rosso L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 96
      WHERE lower(name) = lower('Tempi bui L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 97
      WHERE lower(name) = lower('Grilletto di Dio L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 98
      WHERE lower(name) = lower('Fidel L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 99
      WHERE lower(name) = lower('Sendero luminoso') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 100
      WHERE lower(name) = lower('Var. Sendero luminoso') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 101
      WHERE lower(name) = lower('Tupak amaros') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 102
      WHERE lower(name) = lower('Variante Tupak amaros') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 103
      WHERE lower(name) = lower('Via di 1/2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 104
      WHERE lower(name) = lower('Nannolino cerca l''acqua') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 105
      WHERE lower(name) = lower('Culo di gomma') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 106
      WHERE lower(name) = lower('Ottobre rosso') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 107
      WHERE lower(name) = lower('Regina della notte') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 108
      WHERE lower(name) = lower('Un grammo di paura') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 109
      WHERE lower(name) = lower('Pugni chiusi') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 110
      WHERE lower(name) = lower('Nati in cattività') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 111
      WHERE lower(name) = lower('Anni di piombo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 112
      WHERE lower(name) = lower('Ani di Piombo (Variante Anni di piombo)') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 113
      WHERE lower(name) = lower('Il cerchio nella roccia') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 114
      WHERE lower(name) = lower('Male oscuro') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 115
      WHERE lower(name) = lower('Ekkecazzo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 116
      WHERE lower(name) = lower('Variante Giancola') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 117
      WHERE lower(name) = lower('Diserta il deserto') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 118
      WHERE lower(name) = lower('Rote Armee Fraktion') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 119
      WHERE lower(name) = lower('Balloancora') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 120
      WHERE lower(name) = lower('Il mestiere di vivere') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 121
      WHERE lower(name) = lower('Nulla') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 122
      WHERE lower(name) = lower('Spiritosa') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 123
      WHERE lower(name) = lower('Capelli bianchi') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 124
      WHERE lower(name) = lower('Il tempo è tiranno') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 125
      WHERE lower(name) = lower('Senilità') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 126
      WHERE lower(name) = lower('Via della terza età') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 127
      WHERE lower(name) = lower('Polli di allevamento') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 128
      WHERE lower(name) = lower('Mea culpa') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 129
      WHERE lower(name) = lower('Ecce bombo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 130
      WHERE lower(name) = lower('Montagna ladra') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 131
      WHERE lower(name) = lower('Allegro ma non troppo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 132
      WHERE lower(name) = lower('Variante tazbau') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 133
      WHERE lower(name) = lower('Meco Joni') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 134
      WHERE lower(name) = lower('Il Manifesto') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 135
      WHERE lower(name) = lower('Vita a colori') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 136
      WHERE lower(name) = lower('Come un ramarro') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 137
      WHERE lower(name) = lower('Non sono stato io') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 138
      WHERE lower(name) = lower('Spigolando') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 139
      WHERE lower(name) = lower('Pio 6 1 dio') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 140
      WHERE lower(name) = lower('1960/2010') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 141
      WHERE lower(name) = lower('La placca di Marco') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 142
      WHERE lower(name) = lower('Fessura') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 143
      WHERE lower(name) = lower('Diedro dei 3 gechi') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 144
      WHERE lower(name) = lower('Diedrino di dx') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 145
      WHERE lower(name) = lower('Vecchi e vecchioni') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 146
      WHERE lower(name) = lower('Lo scherzetto') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 147
      WHERE lower(name) = lower('Le due fessure') AND sector_id = v_sector_id;
  ELSE
    RAISE WARNING 'Sector not found: % › %', 'Ripa Majala', 'Settore Principale';
  END IF;

  -- Ripa Majala › Settore Secondario
  SELECT s.id INTO v_sector_id
    FROM sectors s JOIN crags c ON c.id = s.crag_id
    WHERE lower(s.name) = lower('Settore Secondario')
      AND lower(c.name) = lower('Ripa Majala')
    LIMIT 1;
  IF v_sector_id IS NOT NULL THEN
    UPDATE routes SET line_order = 1
      WHERE lower(name) = lower('Facile è bello') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 2
      WHERE lower(name) = lower('Il vecchio che avanza') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 3
      WHERE lower(name) = lower('La cucina di Marina') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 4
      WHERE lower(name) = lower('Le ricette di Marina') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 5
      WHERE lower(name) = lower('Crick e Crock') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 6
      WHERE lower(name) = lower('Alicetta forever') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 7
      WHERE lower(name) = lower('Barman e Robin') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 8
      WHERE lower(name) = lower('Ragazzo di Calabria') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 9
      WHERE lower(name) = lower('Specchio al sole') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 10
      WHERE lower(name) = lower('Nonni folli') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 11
      WHERE lower(name) = lower('Pio amore mio') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 12
      WHERE lower(name) = lower('Ultimo sole') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 13
      WHERE lower(name) = lower('Il ruggito del coniglio') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 14
      WHERE lower(name) = lower('Occhio al nodo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 15
      WHERE lower(name) = lower('La pera amara') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 16
      WHERE lower(name) = lower('Teo dove sei? (variante d''attacco)') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 17
      WHERE lower(name) = lower('Teo dove sei?') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 18
      WHERE lower(name) = lower('Lichene a gogo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 19
      WHERE lower(name) = lower('Il geco ci guarda') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 20
      WHERE lower(name) = lower('Via la folla') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 21
      WHERE lower(name) = lower('Tettino dello speziale') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 22
      WHERE lower(name) = lower('Il pilastrino giallo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 23
      WHERE lower(name) = lower('Diedro di Roberto') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 24
      WHERE lower(name) = lower('Il muschio selvaggio') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 25
      WHERE lower(name) = lower('Spigolo di Roberto') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 26
      WHERE lower(name) = lower('Il buco malefico') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 27
      WHERE lower(name) = lower('Fatti e misfatti') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 28
      WHERE lower(name) = lower('Il moschettone rubato') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 29
      WHERE lower(name) = lower('La spinosa') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 30
      WHERE lower(name) = lower('Fessurina') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 31
      WHERE lower(name) = lower('Ritorno di Gabri') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 32
      WHERE lower(name) = lower('La bomba') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 33
      WHERE lower(name) = lower('Grotta') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 34
      WHERE lower(name) = lower('Senza nome 1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 35
      WHERE lower(name) = lower('Senza nome 2') AND sector_id = v_sector_id;
  ELSE
    RAISE WARNING 'Sector not found: % › %', 'Ripa Majala', 'Settore Secondario';
  END IF;

  -- Colle dell'Orso › Blocco P
  SELECT s.id INTO v_sector_id
    FROM sectors s JOIN crags c ON c.id = s.crag_id
    WHERE lower(s.name) = lower('Blocco P')
      AND lower(c.name) = lower('Colle dell''Orso')
    LIMIT 1;
  IF v_sector_id IS NOT NULL THEN
    UPDATE routes SET line_order = 1
      WHERE lower(name) = lower('Solina') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 2
      WHERE lower(name) = lower('Soletta') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 3
      WHERE lower(name) = lower('Er Macina') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 4
      WHERE lower(name) = lower('Le poissons sur le visage') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 5
      WHERE lower(name) = lower('Patty') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 6
      WHERE lower(name) = lower('Chato') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 7
      WHERE lower(name) = lower('Patata bollente') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 8
      WHERE lower(name) = lower('Falsi miti') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 9
      WHERE lower(name) = lower('Socrate') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 10
      WHERE lower(name) = lower('Il punto oscuro') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 11
      WHERE lower(name) = lower('Il lato oscuro') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 12
      WHERE lower(name) = lower('Schizofrenia') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 13
      WHERE lower(name) = lower('Queimada (variante)') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 14
      WHERE lower(name) = lower('Queimada') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 15
      WHERE lower(name) = lower('Fagian Club') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 16
      WHERE lower(name) = lower('Birra e patatine') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 17
      WHERE lower(name) = lower('Flesh for fantasy') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 18
      WHERE lower(name) = lower('Il tango si balla in due') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 19
      WHERE lower(name) = lower('Olive fritte L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 20
      WHERE lower(name) = lower('Olive fritte L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 21
      WHERE lower(name) = lower('Pantera nera (Latte e caffe'')') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 22
      WHERE lower(name) = lower('Cardine sinistro') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 23
      WHERE lower(name) = lower('Senza nome 1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 24
      WHERE lower(name) = lower('Oltre il cancello') AND sector_id = v_sector_id;
  ELSE
    RAISE WARNING 'Sector not found: % › %', 'Colle dell''Orso', 'Blocco P';
  END IF;

  -- Colle dell'Orso › Blocco Q
  SELECT s.id INTO v_sector_id
    FROM sectors s JOIN crags c ON c.id = s.crag_id
    WHERE lower(s.name) = lower('Blocco Q')
      AND lower(c.name) = lower('Colle dell''Orso')
    LIMIT 1;
  IF v_sector_id IS NOT NULL THEN
    UPDATE routes SET line_order = 1
      WHERE lower(name) = lower('Chicchi live') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 2
      WHERE lower(name) = lower('Cardine destro') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 3
      WHERE lower(name) = lower('Charriba') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 4
      WHERE lower(name) = lower('Senza nome 2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 5
      WHERE lower(name) = lower('Lo scazzo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 6
      WHERE lower(name) = lower('Ciao Tito') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 7
      WHERE lower(name) = lower('The wall of woodoo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 8
      WHERE lower(name) = lower('Senza nome 3') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 9
      WHERE lower(name) = lower('Rapidoil') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 10
      WHERE lower(name) = lower('Verminsugo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 11
      WHERE lower(name) = lower('Pulcinella') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 12
      WHERE lower(name) = lower('Morgialiscia') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 13
      WHERE lower(name) = lower('Stasera mangio tanto lo dico e lo faccio') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 14
      WHERE lower(name) = lower('La roccia di Marco') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 15
      WHERE lower(name) = lower('La via di Marco') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 16
      WHERE lower(name) = lower('La via di Marco (variante)') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 17
      WHERE lower(name) = lower('Seek and destroy') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 18
      WHERE lower(name) = lower('Padre Luciano') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 19
      WHERE lower(name) = lower('Abbi dubbi') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 20
      WHERE lower(name) = lower('Luigi coi blue jeans') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 21
      WHERE lower(name) = lower('Dalle picche al costume') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 22
      WHERE lower(name) = lower('Via Crucis') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 23
      WHERE lower(name) = lower('Irriverenza') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 24
      WHERE lower(name) = lower('Mister Pink') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 25
      WHERE lower(name) = lower('Isolation') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 26
      WHERE lower(name) = lower('Nomadi') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 27
      WHERE lower(name) = lower('Sploosh') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 28
      WHERE lower(name) = lower('Poiana') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 29
      WHERE lower(name) = lower('Cerimonia') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 30
      WHERE lower(name) = lower('L''animale') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 31
      WHERE lower(name) = lower('Inox') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 32
      WHERE lower(name) = lower('Afroclonck') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 33
      WHERE lower(name) = lower('Poldo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 34
      WHERE lower(name) = lower('Il folletto delle morge') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 35
      WHERE lower(name) = lower('Supercrack') AND sector_id = v_sector_id;
  ELSE
    RAISE WARNING 'Sector not found: % › %', 'Colle dell''Orso', 'Blocco Q';
  END IF;

  -- Ulassai › Baccili
  SELECT s.id INTO v_sector_id
    FROM sectors s JOIN crags c ON c.id = s.crag_id
    WHERE lower(s.name) = lower('Baccili')
      AND lower(c.name) = lower('Ulassai')
    LIMIT 1;
  IF v_sector_id IS NOT NULL THEN
    UPDATE routes SET line_order = 1
      WHERE lower(name) = lower('Ganesh') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 2
      WHERE lower(name) = lower('Ganesh L1+L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 3
      WHERE lower(name) = lower('Left behind') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 4
      WHERE lower(name) = lower('Right behind') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 5
      WHERE lower(name) = lower('Discworld') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 6
      WHERE lower(name) = lower('Takatsuki') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 7
      WHERE lower(name) = lower('Lilac') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 8
      WHERE lower(name) = lower('1312') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 9
      WHERE lower(name) = lower('Insanity') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 10
      WHERE lower(name) = lower('Profanity') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 11
      WHERE lower(name) = lower('Ciao Bella') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 12
      WHERE lower(name) = lower('Cannonau') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 13
      WHERE lower(name) = lower('Crack my bitch up L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 14
      WHERE lower(name) = lower('Crack my bitch up L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 15
      WHERE lower(name) = lower('Twisted fire cracker') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 16
      WHERE lower(name) = lower('Goldilocks') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 17
      WHERE lower(name) = lower('Grand Cru') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 18
      WHERE lower(name) = lower('4 orsi bagnati') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 19
      WHERE lower(name) = lower('So you think you can yoga') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 20
      WHERE lower(name) = lower('Gonzo the Maine Coon') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 21
      WHERE lower(name) = lower('Agnese') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 22
      WHERE lower(name) = lower('Taxi easy') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 23
      WHERE lower(name) = lower('Gust') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 24
      WHERE lower(name) = lower('La spalla rotta') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 25
      WHERE lower(name) = lower('Sti cazzi') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 26
      WHERE lower(name) = lower('Rock warriors') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 27
      WHERE lower(name) = lower('Libottentros') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 28
      WHERE lower(name) = lower('48+1') AND sector_id = v_sector_id;
  ELSE
    RAISE WARNING 'Sector not found: % › %', 'Ulassai', 'Baccili';
  END IF;

  -- Ulassai › Cave of Dreams
  SELECT s.id INTO v_sector_id
    FROM sectors s JOIN crags c ON c.id = s.crag_id
    WHERE lower(s.name) = lower('Cave of Dreams')
      AND lower(c.name) = lower('Ulassai')
    LIMIT 1;
  IF v_sector_id IS NOT NULL THEN
    UPDATE routes SET line_order = 1
      WHERE lower(name) = lower('A-pollo One') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 2
      WHERE lower(name) = lower('Crossroads') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 3
      WHERE lower(name) = lower('Opinioni di un Climber') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 4
      WHERE lower(name) = lower('Light my fire') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 5
      WHERE lower(name) = lower('Iuston') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 6
      WHERE lower(name) = lower('We begin') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 7
      WHERE lower(name) = lower('Il manzo di Eraldo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 8
      WHERE lower(name) = lower('Empty wallet') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 9
      WHERE lower(name) = lower('See without looking') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 10
      WHERE lower(name) = lower('B&V') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 11
      WHERE lower(name) = lower('Provolina') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 12
      WHERE lower(name) = lower('Seven') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 13
      WHERE lower(name) = lower('Coincidence or destiny') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 14
      WHERE lower(name) = lower('Frigorifero') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 15
      WHERE lower(name) = lower('Upupa meccanica') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 16
      WHERE lower(name) = lower('Coca light') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 17
      WHERE lower(name) = lower('Senza nome 1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 18
      WHERE lower(name) = lower('Erbalife') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 19
      WHERE lower(name) = lower('La danza dei nerd') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 20
      WHERE lower(name) = lower('Controluce') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 21
      WHERE lower(name) = lower('Cittidì') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 22
      WHERE lower(name) = lower('Why not') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 23
      WHERE lower(name) = lower('Cromo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 24
      WHERE lower(name) = lower('Riglos L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 25
      WHERE lower(name) = lower('Riglos L1+L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 26
      WHERE lower(name) = lower('White out') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 27
      WHERE lower(name) = lower('Silver rope') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 28
      WHERE lower(name) = lower('Pink ball') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 29
      WHERE lower(name) = lower('L''illusione di competere col tempo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 30
      WHERE lower(name) = lower('Free for all') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 31
      WHERE lower(name) = lower('Io chiodo, tu paga') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 32
      WHERE lower(name) = lower('Melo sushi') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 33
      WHERE lower(name) = lower('Nonna Pina e Nonno Angelo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 34
      WHERE lower(name) = lower('Stazione curcuda') AND sector_id = v_sector_id;
  ELSE
    RAISE WARNING 'Sector not found: % › %', 'Ulassai', 'Cave of Dreams';
  END IF;

  -- Ulassai › El Dorado
  SELECT s.id INTO v_sector_id
    FROM sectors s JOIN crags c ON c.id = s.crag_id
    WHERE lower(s.name) = lower('El Dorado')
      AND lower(c.name) = lower('Ulassai')
    LIMIT 1;
  IF v_sector_id IS NOT NULL THEN
    UPDATE routes SET line_order = 1
      WHERE lower(name) = lower('Liposuzione') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 2
      WHERE lower(name) = lower('Effetto doppler') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 3
      WHERE lower(name) = lower('Killer Pablito') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 4
      WHERE lower(name) = lower('Caballo desbocado') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 5
      WHERE lower(name) = lower('Carovana') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 6
      WHERE lower(name) = lower('Il furbetto L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 7
      WHERE lower(name) = lower('Il furbetto L1+L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 8
      WHERE lower(name) = lower('Nuovo mondo L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 9
      WHERE lower(name) = lower('Nuovo mondo L1+L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 10
      WHERE lower(name) = lower('El Dorado') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 11
      WHERE lower(name) = lower('La strada per el dorado') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 12
      WHERE lower(name) = lower('Il missionario') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 13
      WHERE lower(name) = lower('Junkie paradise') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 14
      WHERE lower(name) = lower('Risonanzà L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 15
      WHERE lower(name) = lower('Risonanzà L1+L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 16
      WHERE lower(name) = lower('Empatia e moralità') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 17
      WHERE lower(name) = lower('La bella Ila') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 18
      WHERE lower(name) = lower('Mimimi') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 19
      WHERE lower(name) = lower('Non una di meno L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 20
      WHERE lower(name) = lower('Non una di meno L1+L2') AND sector_id = v_sector_id;
  ELSE
    RAISE WARNING 'Sector not found: % › %', 'Ulassai', 'El Dorado';
  END IF;

  -- Ulassai › Il Canyon
  SELECT s.id INTO v_sector_id
    FROM sectors s JOIN crags c ON c.id = s.crag_id
    WHERE lower(s.name) = lower('Il Canyon')
      AND lower(c.name) = lower('Ulassai')
    LIMIT 1;
  IF v_sector_id IS NOT NULL THEN
    UPDATE routes SET line_order = 1
      WHERE lower(name) = lower('Giulia') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 2
      WHERE lower(name) = lower('Hotel Su Murmuri') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 3
      WHERE lower(name) = lower('Cavineddu') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 4
      WHERE lower(name) = lower('1, 2 donne') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 5
      WHERE lower(name) = lower('Cloaca') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 6
      WHERE lower(name) = lower('Tom') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 7
      WHERE lower(name) = lower('Jerry') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 8
      WHERE lower(name) = lower('Intrusi sospetti') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 9
      WHERE lower(name) = lower('Vision Crack') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 10
      WHERE lower(name) = lower('Molto rumore per nulla') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 11
      WHERE lower(name) = lower('Ricordati di me') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 12
      WHERE lower(name) = lower('Arcipelaghi L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 13
      WHERE lower(name) = lower('Il coyote L1+L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 14
      WHERE lower(name) = lower('Educanza L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 15
      WHERE lower(name) = lower('Mezza pizzetta L1+L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 16
      WHERE lower(name) = lower('Nonluogo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 17
      WHERE lower(name) = lower('Disamore') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 18
      WHERE lower(name) = lower('Cattolico decoro') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 19
      WHERE lower(name) = lower('Lacrime di coccodrillo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 20
      WHERE lower(name) = lower('Coccole e magnesite') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 21
      WHERE lower(name) = lower('Hamtaro') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 22
      WHERE lower(name) = lower('Tarantula') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 23
      WHERE lower(name) = lower('Tasmania') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 24
      WHERE lower(name) = lower('Quinto') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 25
      WHERE lower(name) = lower('Maladittu siasta') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 26
      WHERE lower(name) = lower('Aquila Skalza') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 27
      WHERE lower(name) = lower('Già lo sai') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 28
      WHERE lower(name) = lower('Up') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 29
      WHERE lower(name) = lower('Koda') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 30
      WHERE lower(name) = lower('Kenai') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 31
      WHERE lower(name) = lower('La reina') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 32
      WHERE lower(name) = lower('Zinghi') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 33
      WHERE lower(name) = lower('Niagara') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 34
      WHERE lower(name) = lower('Nazarè') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 35
      WHERE lower(name) = lower('Prozac Blues') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 36
      WHERE lower(name) = lower('Artattak L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 37
      WHERE lower(name) = lower('Pescecane L1+L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 38
      WHERE lower(name) = lower('Ladri scalatori') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 39
      WHERE lower(name) = lower('Pasqua bagnata') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 40
      WHERE lower(name) = lower('Flower crack L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 41
      WHERE lower(name) = lower('Flower crack L1+L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 42
      WHERE lower(name) = lower('The Lobster') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 43
      WHERE lower(name) = lower('Crystal waves') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 44
      WHERE lower(name) = lower('Tuco Ramirez') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 45
      WHERE lower(name) = lower('I nodi vengono al pettine') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 46
      WHERE lower(name) = lower('Buonuomo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 47
      WHERE lower(name) = lower('Fruttolo L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 48
      WHERE lower(name) = lower('Fruttolo L1+L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 49
      WHERE lower(name) = lower('Aggannammala') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 50
      WHERE lower(name) = lower('Zitto e tira!') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 51
      WHERE lower(name) = lower('Mina vagante') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 52
      WHERE lower(name) = lower('Ta peccau') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 53
      WHERE lower(name) = lower('Trottolina') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 54
      WHERE lower(name) = lower('La danza del maestrale') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 55
      WHERE lower(name) = lower('Sabagas') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 56
      WHERE lower(name) = lower('Nebbia') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 57
      WHERE lower(name) = lower('Anisakis') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 58
      WHERE lower(name) = lower('Caccia alle streghe') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 59
      WHERE lower(name) = lower('Meda') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 60
      WHERE lower(name) = lower('Intervista col vampiro L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 61
      WHERE lower(name) = lower('Intervista col vampiro L1+L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 62
      WHERE lower(name) = lower('Ecco Dati') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 63
      WHERE lower(name) = lower('Senza nome 1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 64
      WHERE lower(name) = lower('Bolle di sapone') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 65
      WHERE lower(name) = lower('Savoiardo d''Egitto') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 66
      WHERE lower(name) = lower('Sugo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 67
      WHERE lower(name) = lower('L''uomo senz''anima') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 68
      WHERE lower(name) = lower('Still alive') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 69
      WHERE lower(name) = lower('Il fanfarone') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 70
      WHERE lower(name) = lower('Forcefit') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 71
      WHERE lower(name) = lower('Stiziaticodidioi') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 72
      WHERE lower(name) = lower('Trilobite') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 73
      WHERE lower(name) = lower('Nuraghe (SCHIODATA)') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 74
      WHERE lower(name) = lower('Snake Eye') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 75
      WHERE lower(name) = lower('Neverwhere') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 76
      WHERE lower(name) = lower('Fiona diretta') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 77
      WHERE lower(name) = lower('Fiona') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 78
      WHERE lower(name) = lower('Clio') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 79
      WHERE lower(name) = lower('Blu') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 80
      WHERE lower(name) = lower('Olieningrado') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 81
      WHERE lower(name) = lower('Bad Joke') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 82
      WHERE lower(name) = lower('Anemnesi') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 83
      WHERE lower(name) = lower('L''aria') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 84
      WHERE lower(name) = lower('Nido di draghi') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 85
      WHERE lower(name) = lower('Mexina') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 86
      WHERE lower(name) = lower('Sudottori') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 87
      WHERE lower(name) = lower('Tossisca') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 88
      WHERE lower(name) = lower('Fura fura (SCHIODATA)') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 89
      WHERE lower(name) = lower('Fura crabasa (SCHIODATA)') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 90
      WHERE lower(name) = lower('Osculto') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 91
      WHERE lower(name) = lower('Kajoe') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 92
      WHERE lower(name) = lower('Sun and bass') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 93
      WHERE lower(name) = lower('Hugs e kisses') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 94
      WHERE lower(name) = lower('Dica 33') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 95
      WHERE lower(name) = lower('Spiedl dl ana') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 96
      WHERE lower(name) = lower('Sas Viv') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 97
      WHERE lower(name) = lower('False promesse') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 98
      WHERE lower(name) = lower('Il passo del fandango') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 99
      WHERE lower(name) = lower('Passo doble') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 100
      WHERE lower(name) = lower('Abbardente tomorrow i''m a flower') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 101
      WHERE lower(name) = lower('Checiapp') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 102
      WHERE lower(name) = lower('Fiocchetti e palmette') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 103
      WHERE lower(name) = lower('Manu''s paradise') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 104
      WHERE lower(name) = lower('Belin') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 105
      WHERE lower(name) = lower('Succio… è') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 106
      WHERE lower(name) = lower('Praticamente no!') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 107
      WHERE lower(name) = lower('Gli apostoli') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 108
      WHERE lower(name) = lower('Nebia') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 109
      WHERE lower(name) = lower('The leisure princess') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 110
      WHERE lower(name) = lower('The purple gecko galaxy') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 111
      WHERE lower(name) = lower('Tre soldi') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 112
      WHERE lower(name) = lower('Peppino e Peppina') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 113
      WHERE lower(name) = lower('Rebecca') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 114
      WHERE lower(name) = lower('Pissenlove') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 115
      WHERE lower(name) = lower('Zimo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 116
      WHERE lower(name) = lower('Criminally') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 117
      WHERE lower(name) = lower('Mummietta') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 118
      WHERE lower(name) = lower('Giolla') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 119
      WHERE lower(name) = lower('Cicciosauro') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 120
      WHERE lower(name) = lower('Cicciasaura') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 121
      WHERE lower(name) = lower('Formicuzza') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 122
      WHERE lower(name) = lower('Crepa cuore') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 123
      WHERE lower(name) = lower('Barra dei leppuri') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 124
      WHERE lower(name) = lower('Carola block') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 125
      WHERE lower(name) = lower('Cavità sensuali') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 126
      WHERE lower(name) = lower('Diagolal theatre') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 127
      WHERE lower(name) = lower('B.I.C.') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 128
      WHERE lower(name) = lower('Spritz litz') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 129
      WHERE lower(name) = lower('L''igienista') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 130
      WHERE lower(name) = lower('Estigazzi') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 131
      WHERE lower(name) = lower('Sammi') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 132
      WHERE lower(name) = lower('Patata volante') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 133
      WHERE lower(name) = lower('Miki superstar') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 134
      WHERE lower(name) = lower('Piccola mou') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 135
      WHERE lower(name) = lower('Via campo sportivo nr.1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 136
      WHERE lower(name) = lower('High school girls') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 137
      WHERE lower(name) = lower('History repeating') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 138
      WHERE lower(name) = lower('Emelie''s first steps') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 139
      WHERE lower(name) = lower('Peppa pig') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 140
      WHERE lower(name) = lower('Ponio') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 141
      WHERE lower(name) = lower('Lamù') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 142
      WHERE lower(name) = lower('Pio pio') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 143
      WHERE lower(name) = lower('Caterpillar Mario') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 144
      WHERE lower(name) = lower('Empia Spiga') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 145
      WHERE lower(name) = lower('Pino solitario') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 146
      WHERE lower(name) = lower('Semini fini') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 147
      WHERE lower(name) = lower('Pane') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 148
      WHERE lower(name) = lower('Nutella') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 149
      WHERE lower(name) = lower('Minimo decoro') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 150
      WHERE lower(name) = lower('Questione di pitting') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 151
      WHERE lower(name) = lower('Baby body painting') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 152
      WHERE lower(name) = lower('Sfigatello') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 153
      WHERE lower(name) = lower('Fuerte e ventura') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 154
      WHERE lower(name) = lower('Bulgarmente') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 155
      WHERE lower(name) = lower('Bocabulario') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 156
      WHERE lower(name) = lower('Lole') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 157
      WHERE lower(name) = lower('Amaramura') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 158
      WHERE lower(name) = lower('Marinella boulder') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 159
      WHERE lower(name) = lower('Cristina Canarina') AND sector_id = v_sector_id;
  ELSE
    RAISE WARNING 'Sector not found: % › %', 'Ulassai', 'Il Canyon';
  END IF;

  -- Ulassai › Inquietudini
  SELECT s.id INTO v_sector_id
    FROM sectors s JOIN crags c ON c.id = s.crag_id
    WHERE lower(s.name) = lower('Inquietudini')
      AND lower(c.name) = lower('Ulassai')
    LIMIT 1;
  IF v_sector_id IS NOT NULL THEN
    UPDATE routes SET line_order = 1
      WHERE lower(name) = lower('Monster & Co') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 2
      WHERE lower(name) = lower('El dieguito enfurecido') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 3
      WHERE lower(name) = lower('Black Mamba') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 4
      WHERE lower(name) = lower('Shenron dragon') AND sector_id = v_sector_id;
  ELSE
    RAISE WARNING 'Sector not found: % › %', 'Ulassai', 'Inquietudini';
  END IF;

  -- Ulassai › Is Janas
  SELECT s.id INTO v_sector_id
    FROM sectors s JOIN crags c ON c.id = s.crag_id
    WHERE lower(s.name) = lower('Is Janas')
      AND lower(c.name) = lower('Ulassai')
    LIMIT 1;
  IF v_sector_id IS NOT NULL THEN
    UPDATE routes SET line_order = 1
      WHERE lower(name) = lower('Nanny Ogg.') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 2
      WHERE lower(name) = lower('Greebo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 3
      WHERE lower(name) = lower('Lilia') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 4
      WHERE lower(name) = lower('Acqua vite') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 5
      WHERE lower(name) = lower('Water life') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 6
      WHERE lower(name) = lower('Sa janitedda') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 7
      WHERE lower(name) = lower('Puzza di gatto') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 8
      WHERE lower(name) = lower('Bocca di rosa') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 9
      WHERE lower(name) = lower('Silence') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 10
      WHERE lower(name) = lower('Anunnaki') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 11
      WHERE lower(name) = lower('Caffè scorretto') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 12
      WHERE lower(name) = lower('Tozo on tour') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 13
      WHERE lower(name) = lower('Per l''amore di Theo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 14
      WHERE lower(name) = lower('Bene Gesserit') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 15
      WHERE lower(name) = lower('Shai-Hulud') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 16
      WHERE lower(name) = lower('Occhi azzurri') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 17
      WHERE lower(name) = lower('Nog een nijntjes nektapijt') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 18
      WHERE lower(name) = lower('Trust your flake') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 19
      WHERE lower(name) = lower('Azabuba') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 20
      WHERE lower(name) = lower('Ex-runout') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 21
      WHERE lower(name) = lower('Vento in fessa') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 22
      WHERE lower(name) = lower('Gancanach') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 23
      WHERE lower(name) = lower('Un viaggio con Tony') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 24
      WHERE lower(name) = lower('Aradia') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 25
      WHERE lower(name) = lower('Nicnivin') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 26
      WHERE lower(name) = lower('Doggando') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 27
      WHERE lower(name) = lower('Cool Abdul') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 28
      WHERE lower(name) = lower('Sexual healing') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 29
      WHERE lower(name) = lower('Savannah') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 30
      WHERE lower(name) = lower('L''ombra del vento') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 31
      WHERE lower(name) = lower('100 culurgiones') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 32
      WHERE lower(name) = lower('Dr. Google') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 33
      WHERE lower(name) = lower('Muscles from brussels') AND sector_id = v_sector_id;
  ELSE
    RAISE WARNING 'Sector not found: % › %', 'Ulassai', 'Is Janas';
  END IF;

  -- Ulassai › La Piramide
  SELECT s.id INTO v_sector_id
    FROM sectors s JOIN crags c ON c.id = s.crag_id
    WHERE lower(s.name) = lower('La Piramide')
      AND lower(c.name) = lower('Ulassai')
    LIMIT 1;
  IF v_sector_id IS NOT NULL THEN
    UPDATE routes SET line_order = 1
      WHERE lower(name) = lower('Anubi') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 2
      WHERE lower(name) = lower('Cheope') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 3
      WHERE lower(name) = lower('Amon') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 4
      WHERE lower(name) = lower('Bastet') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 5
      WHERE lower(name) = lower('Mut') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 6
      WHERE lower(name) = lower('Set') AND sector_id = v_sector_id;
  ELSE
    RAISE WARNING 'Sector not found: % › %', 'Ulassai', 'La Piramide';
  END IF;

  -- Ulassai › Lecorci
  SELECT s.id INTO v_sector_id
    FROM sectors s JOIN crags c ON c.id = s.crag_id
    WHERE lower(s.name) = lower('Lecorci')
      AND lower(c.name) = lower('Ulassai')
    LIMIT 1;
  IF v_sector_id IS NOT NULL THEN
    UPDATE routes SET line_order = 1
      WHERE lower(name) = lower('Panta rei') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 2
      WHERE lower(name) = lower('Astragalo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 3
      WHERE lower(name) = lower('Boomerang') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 4
      WHERE lower(name) = lower('Ubi maior') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 5
      WHERE lower(name) = lower('The watchtower L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 6
      WHERE lower(name) = lower('All along the watchtower L1+L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 7
      WHERE lower(name) = lower('Hard Bitch') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 8
      WHERE lower(name) = lower('Rafiki L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 9
      WHERE lower(name) = lower('Rafiki ext L1+L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 10
      WHERE lower(name) = lower('Minor cessat') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 11
      WHERE lower(name) = lower('Coming back') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 12
      WHERE lower(name) = lower('Stay away') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 13
      WHERE lower(name) = lower('Kaftrio') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 14
      WHERE lower(name) = lower('Tito') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 15
      WHERE lower(name) = lower('Alfa') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 16
      WHERE lower(name) = lower('Drago nero') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 17
      WHERE lower(name) = lower('Rurp') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 18
      WHERE lower(name) = lower('Mira il dito') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 19
      WHERE lower(name) = lower('Doomsday') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 20
      WHERE lower(name) = lower('Doomsday è bella così L1+L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 21
      WHERE lower(name) = lower('Bella così') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 22
      WHERE lower(name) = lower('Bellissima così L1+L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 23
      WHERE lower(name) = lower('Apparenza') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 24
      WHERE lower(name) = lower('Dieta ferrea') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 25
      WHERE lower(name) = lower('Protuberanza equina') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 26
      WHERE lower(name) = lower('Regime alimentare') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 27
      WHERE lower(name) = lower('Spina') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 28
      WHERE lower(name) = lower('Bobolone') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 29
      WHERE lower(name) = lower('Chichino') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 30
      WHERE lower(name) = lower('Buchi buchi') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 31
      WHERE lower(name) = lower('Senza nome') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 32
      WHERE lower(name) = lower('Lisio') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 33
      WHERE lower(name) = lower('Frigo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 34
      WHERE lower(name) = lower('Gino') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 35
      WHERE lower(name) = lower('Pino') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 36
      WHERE lower(name) = lower('Nino') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 37
      WHERE lower(name) = lower('Fammi vedere le tette') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 38
      WHERE lower(name) = lower('Spaghetti al rovo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 39
      WHERE lower(name) = lower('Stanza') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 40
      WHERE lower(name) = lower('Atti di clemenza') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 41
      WHERE lower(name) = lower('Zuccherino') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 42
      WHERE lower(name) = lower('Tap') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 43
      WHERE lower(name) = lower('Tip L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 44
      WHERE lower(name) = lower('A''bombazza L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 45
      WHERE lower(name) = lower('Esagerato') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 46
      WHERE lower(name) = lower('MCB L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 47
      WHERE lower(name) = lower('TVB L1+L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 48
      WHERE lower(name) = lower('MDF L1+L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 49
      WHERE lower(name) = lower('Pipo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 50
      WHERE lower(name) = lower('Liz') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 51
      WHERE lower(name) = lower('Mezzo tiro') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 52
      WHERE lower(name) = lower('La mano bianca') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 53
      WHERE lower(name) = lower('The laughing heart') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 54
      WHERE lower(name) = lower('Aiutante') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 55
      WHERE lower(name) = lower('Pugnali volanti') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 56
      WHERE lower(name) = lower('Vulcano') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 57
      WHERE lower(name) = lower('Canna cinese') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 58
      WHERE lower(name) = lower('Dolce banana') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 59
      WHERE lower(name) = lower('Dimenticanze') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 60
      WHERE lower(name) = lower('Block') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 61
      WHERE lower(name) = lower('Spakka') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 62
      WHERE lower(name) = lower('Showroom dummies') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 63
      WHERE lower(name) = lower('Croce e delizia') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 64
      WHERE lower(name) = lower('P.T.') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 65
      WHERE lower(name) = lower('Ghost writer') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 66
      WHERE lower(name) = lower('La trama del tempo L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 67
      WHERE lower(name) = lower('La trama del tempo L1+L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 68
      WHERE lower(name) = lower('Red cut') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 69
      WHERE lower(name) = lower('Bricolage') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 70
      WHERE lower(name) = lower('Tentazioni') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 71
      WHERE lower(name) = lower('Sinto') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 72
      WHERE lower(name) = lower('Finto') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 73
      WHERE lower(name) = lower('Pinto') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 74
      WHERE lower(name) = lower('Rovo di bosco') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 75
      WHERE lower(name) = lower('Kill Bill') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 76
      WHERE lower(name) = lower('Sorgente') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 77
      WHERE lower(name) = lower('Gocce di memoria') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 78
      WHERE lower(name) = lower('Indomabile') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 79
      WHERE lower(name) = lower('Grillo sacente') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 80
      WHERE lower(name) = lower('Mo...viola') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 81
      WHERE lower(name) = lower('Movimenti socratici') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 82
      WHERE lower(name) = lower('Umori al vespero') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 83
      WHERE lower(name) = lower('Short and nameless') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 84
      WHERE lower(name) = lower('Sottobosco') AND sector_id = v_sector_id;
  ELSE
    RAISE WARNING 'Sector not found: % › %', 'Ulassai', 'Lecorci';
  END IF;

  -- Ulassai › Marosini
  SELECT s.id INTO v_sector_id
    FROM sectors s JOIN crags c ON c.id = s.crag_id
    WHERE lower(s.name) = lower('Marosini')
      AND lower(c.name) = lower('Ulassai')
    LIMIT 1;
  IF v_sector_id IS NOT NULL THEN
    UPDATE routes SET line_order = 1
      WHERE lower(name) = lower('Saluto al sole') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 2
      WHERE lower(name) = lower('Eagle Eye') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 3
      WHERE lower(name) = lower('Rocket Pocket') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 4
      WHERE lower(name) = lower('Geo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 5
      WHERE lower(name) = lower('Pussy wagon') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 6
      WHERE lower(name) = lower('Esperienza senile') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 7
      WHERE lower(name) = lower('Krabfarm') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 8
      WHERE lower(name) = lower('Mister arete') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 9
      WHERE lower(name) = lower('Capitalismo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 10
      WHERE lower(name) = lower('Spazzolino rotto') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 11
      WHERE lower(name) = lower('Frankie''s finale') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 12
      WHERE lower(name) = lower('Poodelwoodelywoopsy') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 13
      WHERE lower(name) = lower('FK') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 14
      WHERE lower(name) = lower('Culurgiones') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 15
      WHERE lower(name) = lower('Murales') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 16
      WHERE lower(name) = lower('The alchemist') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 17
      WHERE lower(name) = lower('No country for young man') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 18
      WHERE lower(name) = lower('Yea vez') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 19
      WHERE lower(name) = lower('Grande vez') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 20
      WHERE lower(name) = lower('Mononoke L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 21
      WHERE lower(name) = lower('Mononoke L1+L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 22
      WHERE lower(name) = lower('Mononoke L1+L2+L3') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 23
      WHERE lower(name) = lower('Spriggan L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 24
      WHERE lower(name) = lower('Spriggan L1+L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 25
      WHERE lower(name) = lower('Angry hippies') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 26
      WHERE lower(name) = lower('Highlines') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 27
      WHERE lower(name) = lower('Rosse armee fraction') AND sector_id = v_sector_id;
  ELSE
    RAISE WARNING 'Sector not found: % › %', 'Ulassai', 'Marosini';
  END IF;

  -- Ulassai › Opera
  SELECT s.id INTO v_sector_id
    FROM sectors s JOIN crags c ON c.id = s.crag_id
    WHERE lower(s.name) = lower('Opera')
      AND lower(c.name) = lower('Ulassai')
    LIMIT 1;
  IF v_sector_id IS NOT NULL THEN
    UPDATE routes SET line_order = 1
      WHERE lower(name) = lower('Magica medicina') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 2
      WHERE lower(name) = lower('La fabbrica di cioccolata') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 3
      WHERE lower(name) = lower('Il gattopardo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 4
      WHERE lower(name) = lower('On the road') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 5
      WHERE lower(name) = lower('La leggerezza dell''essere') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 6
      WHERE lower(name) = lower('Le radici del cielo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 7
      WHERE lower(name) = lower('La gabbianella e il gatto') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 8
      WHERE lower(name) = lower('Shining') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 9
      WHERE lower(name) = lower('Il nome della rosa') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 10
      WHERE lower(name) = lower('Cuore di tenebra') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 11
      WHERE lower(name) = lower('Il monte analogo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 12
      WHERE lower(name) = lower('L''interpretazione dei sogni') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 13
      WHERE lower(name) = lower('La metamorfosi') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 14
      WHERE lower(name) = lower('L''ombra dello scorpione') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 15
      WHERE lower(name) = lower('Il muro') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 16
      WHERE lower(name) = lower('Lo straniero') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 17
      WHERE lower(name) = lower('La realtà separata') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 18
      WHERE lower(name) = lower('Siddharta') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 19
      WHERE lower(name) = lower('Il dio delle piccole cose') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 20
      WHERE lower(name) = lower('Musasti') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 21
      WHERE lower(name) = lower('Zanna Bianca') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 22
      WHERE lower(name) = lower('Tom Sawyer') AND sector_id = v_sector_id;
  ELSE
    RAISE WARNING 'Sector not found: % › %', 'Ulassai', 'Opera';
  END IF;

  -- Ulassai › S'Assa Bella
  SELECT s.id INTO v_sector_id
    FROM sectors s JOIN crags c ON c.id = s.crag_id
    WHERE lower(s.name) = lower('S''Assa Bella')
      AND lower(c.name) = lower('Ulassai')
    LIMIT 1;
  IF v_sector_id IS NOT NULL THEN
    UPDATE routes SET line_order = 1
      WHERE lower(name) = lower('Tomba Oscura') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 2
      WHERE lower(name) = lower('Campeggio eterno') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 3
      WHERE lower(name) = lower('Poser') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 4
      WHERE lower(name) = lower('M''inchino') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 5
      WHERE lower(name) = lower('Su tasinanta') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 6
      WHERE lower(name) = lower('Beccamorto') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 7
      WHERE lower(name) = lower('Pannelli solari e polpi') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 8
      WHERE lower(name) = lower('Tutto tu vuole') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 9
      WHERE lower(name) = lower('Seta morbida') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 10
      WHERE lower(name) = lower('Time to shave') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 11
      WHERE lower(name) = lower('Bella zia') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 12
      WHERE lower(name) = lower('Barba Gianni') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 13
      WHERE lower(name) = lower('Miss Coolio') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 14
      WHERE lower(name) = lower('Don Abbondio') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 15
      WHERE lower(name) = lower('Minchecua') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 16
      WHERE lower(name) = lower('Il cinghiale') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 17
      WHERE lower(name) = lower('Offerta grazie al cazzo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 18
      WHERE lower(name) = lower('Basta Marco L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 19
      WHERE lower(name) = lower('Detonati L1+L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 20
      WHERE lower(name) = lower('Vai Polleg') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 21
      WHERE lower(name) = lower('Salvini merda') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 22
      WHERE lower(name) = lower('Porkatron') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 23
      WHERE lower(name) = lower('L''alcolista') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 24
      WHERE lower(name) = lower('I think I smell aerie L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 25
      WHERE lower(name) = lower('I think I smell aerie L1+L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 26
      WHERE lower(name) = lower('Bolle dal culo L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 27
      WHERE lower(name) = lower('Hungarian dance L1+L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 28
      WHERE lower(name) = lower('Clandestino') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 29
      WHERE lower(name) = lower('Nanna ice cream') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 30
      WHERE lower(name) = lower('Wie heeft mijn setjes') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 31
      WHERE lower(name) = lower('Poopoo police') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 32
      WHERE lower(name) = lower('Rita') AND sector_id = v_sector_id;
  ELSE
    RAISE WARNING 'Sector not found: % › %', 'Ulassai', 'S''Assa Bella';
  END IF;

  -- Ulassai › Sa Matta Prana
  SELECT s.id INTO v_sector_id
    FROM sectors s JOIN crags c ON c.id = s.crag_id
    WHERE lower(s.name) = lower('Sa Matta Prana')
      AND lower(c.name) = lower('Ulassai')
    LIMIT 1;
  IF v_sector_id IS NOT NULL THEN
    UPDATE routes SET line_order = 1
      WHERE lower(name) = lower('Ondarossa') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 2
      WHERE lower(name) = lower('Pattada & wheels') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 3
      WHERE lower(name) = lower('Senza nome 1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 4
      WHERE lower(name) = lower('Années sauvages') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 5
      WHERE lower(name) = lower('Senza nome 2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 6
      WHERE lower(name) = lower('Senza nome 3') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 7
      WHERE lower(name) = lower('Feeding the algorithm') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 8
      WHERE lower(name) = lower('Senza nome 4') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 9
      WHERE lower(name) = lower('Senza nome 5') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 10
      WHERE lower(name) = lower('Riding for a fall') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 11
      WHERE lower(name) = lower('Senza nome 6') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 12
      WHERE lower(name) = lower('Senza nome 7') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 13
      WHERE lower(name) = lower('Senza nome 8') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 14
      WHERE lower(name) = lower('Spiderman') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 15
      WHERE lower(name) = lower('La streghetta') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 16
      WHERE lower(name) = lower('Omineddu antigu') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 17
      WHERE lower(name) = lower('Giovedì grasso') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 18
      WHERE lower(name) = lower('Senza nome 9') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 19
      WHERE lower(name) = lower('Power of now') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 20
      WHERE lower(name) = lower('Senza nome 10') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 21
      WHERE lower(name) = lower('Satori') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 22
      WHERE lower(name) = lower('Papi le gusta el Chile') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 23
      WHERE lower(name) = lower('Mamacita') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 24
      WHERE lower(name) = lower('Senza nome 11') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 25
      WHERE lower(name) = lower('Eschaton') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 26
      WHERE lower(name) = lower('Senza nome 12') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 27
      WHERE lower(name) = lower('Triple rocket') AND sector_id = v_sector_id;
  ELSE
    RAISE WARNING 'Sector not found: % › %', 'Ulassai', 'Sa Matta Prana';
  END IF;

  -- Ulassai › Scala 'e predi
  SELECT s.id INTO v_sector_id
    FROM sectors s JOIN crags c ON c.id = s.crag_id
    WHERE lower(s.name) = lower('Scala ''e predi')
      AND lower(c.name) = lower('Ulassai')
    LIMIT 1;
  IF v_sector_id IS NOT NULL THEN
    UPDATE routes SET line_order = 1
      WHERE lower(name) = lower('Erre erre') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 2
      WHERE lower(name) = lower('Pepe al culo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 3
      WHERE lower(name) = lower('ATP') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 4
      WHERE lower(name) = lower('Bella di notte') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 5
      WHERE lower(name) = lower('Prisoner of child') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 6
      WHERE lower(name) = lower('Bluebird') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 7
      WHERE lower(name) = lower('Swing it like Roger') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 8
      WHERE lower(name) = lower('Augusto terapia') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 9
      WHERE lower(name) = lower('Altrimenti ci arrabbiamo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 10
      WHERE lower(name) = lower('Nonno Cece') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 11
      WHERE lower(name) = lower('Sasha bella') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 12
      WHERE lower(name) = lower('Giuanni Aledda 102') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 13
      WHERE lower(name) = lower('L''anisiello Nunù') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 14
      WHERE lower(name) = lower('Formica terapia') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 15
      WHERE lower(name) = lower('Bo!!!') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 16
      WHERE lower(name) = lower('Il molecolare') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 17
      WHERE lower(name) = lower('Negativo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 18
      WHERE lower(name) = lower('New style') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 19
      WHERE lower(name) = lower('E... che cazzo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 20
      WHERE lower(name) = lower('Aleksänder') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 21
      WHERE lower(name) = lower('Monnalisa') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 22
      WHERE lower(name) = lower('Cambiamenti') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 23
      WHERE lower(name) = lower('Love me two times') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 24
      WHERE lower(name) = lower('Baciami ancora') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 25
      WHERE lower(name) = lower('Scintilla') AND sector_id = v_sector_id;
  ELSE
    RAISE WARNING 'Sector not found: % › %', 'Ulassai', 'Scala ''e predi';
  END IF;

  -- Ulassai › Scala Ussassa
  SELECT s.id INTO v_sector_id
    FROM sectors s JOIN crags c ON c.id = s.crag_id
    WHERE lower(s.name) = lower('Scala Ussassa')
      AND lower(c.name) = lower('Ulassai')
    LIMIT 1;
  IF v_sector_id IS NOT NULL THEN
    UPDATE routes SET line_order = 1
      WHERE lower(name) = lower('Vivi libero o muori') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 2
      WHERE lower(name) = lower('Chasing the scream L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 3
      WHERE lower(name) = lower('Chasing the scream L1+L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 4
      WHERE lower(name) = lower('Effective altruism') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 5
      WHERE lower(name) = lower('Anansi') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 6
      WHERE lower(name) = lower('Un atto di fede L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 7
      WHERE lower(name) = lower('Un atto di fede L1+L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 8
      WHERE lower(name) = lower('At the gates') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 9
      WHERE lower(name) = lower('Finn Sue') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 10
      WHERE lower(name) = lower('Mandumbo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 11
      WHERE lower(name) = lower('Check yo self') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 12
      WHERE lower(name) = lower('Team lazer line') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 13
      WHERE lower(name) = lower('Abomba') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 14
      WHERE lower(name) = lower('Lord flashheart') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 15
      WHERE lower(name) = lower('Capitain slackbladder') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 16
      WHERE lower(name) = lower('Agent orange') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 17
      WHERE lower(name) = lower('Un giorno di pioggia') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 18
      WHERE lower(name) = lower('Giusto è giusto') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 19
      WHERE lower(name) = lower('Catching up') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 20
      WHERE lower(name) = lower('Bella ciao') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 21
      WHERE lower(name) = lower('Gatekeeper') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 22
      WHERE lower(name) = lower('Substance of shadows') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 23
      WHERE lower(name) = lower('I predatori dei ciucci perduti') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 24
      WHERE lower(name) = lower('Darko') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 25
      WHERE lower(name) = lower('Battousai') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 26
      WHERE lower(name) = lower('Senza nome 1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 27
      WHERE lower(name) = lower('Trebenna L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 28
      WHERE lower(name) = lower('Trebenna L1+L2') AND sector_id = v_sector_id;
  ELSE
    RAISE WARNING 'Sector not found: % › %', 'Ulassai', 'Scala Ussassa';
  END IF;

  -- Ulassai › Sopravento
  SELECT s.id INTO v_sector_id
    FROM sectors s JOIN crags c ON c.id = s.crag_id
    WHERE lower(s.name) = lower('Sopravento')
      AND lower(c.name) = lower('Ulassai')
    LIMIT 1;
  IF v_sector_id IS NOT NULL THEN
    UPDATE routes SET line_order = 1
      WHERE lower(name) = lower('Shiver mi whiskers') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 2
      WHERE lower(name) = lower('6 piedi sotto la luna') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 3
      WHERE lower(name) = lower('Melone melone') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 4
      WHERE lower(name) = lower('King''s Cross') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 5
      WHERE lower(name) = lower('La sete di Squiki') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 6
      WHERE lower(name) = lower('The colour prince') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 7
      WHERE lower(name) = lower('Salty wind') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 8
      WHERE lower(name) = lower('Tigre d''Ogliastra') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 9
      WHERE lower(name) = lower('So you think you can climb?') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 10
      WHERE lower(name) = lower('Goat licker') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 11
      WHERE lower(name) = lower('What''s cracking') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 12
      WHERE lower(name) = lower('Jhonny sends') AND sector_id = v_sector_id;
  ELSE
    RAISE WARNING 'Sector not found: % › %', 'Ulassai', 'Sopravento';
  END IF;

  -- Ulassai › Su Casteddu
  SELECT s.id INTO v_sector_id
    FROM sectors s JOIN crags c ON c.id = s.crag_id
    WHERE lower(s.name) = lower('Su Casteddu')
      AND lower(c.name) = lower('Ulassai')
    LIMIT 1;
  IF v_sector_id IS NOT NULL THEN
    UPDATE routes SET line_order = 1
      WHERE lower(name) = lower('Baldur''s gate') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 2
      WHERE lower(name) = lower('Hier kommt Alex') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 3
      WHERE lower(name) = lower('Stuck in starlight') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 4
      WHERE lower(name) = lower('No foefelare') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 5
      WHERE lower(name) = lower('Roos&Floor') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 6
      WHERE lower(name) = lower('Mental breakdown') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 7
      WHERE lower(name) = lower('Gugu e lupo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 8
      WHERE lower(name) = lower('Goatrider') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 9
      WHERE lower(name) = lower('Goatbuster') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 10
      WHERE lower(name) = lower('Waki') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 11
      WHERE lower(name) = lower('Buling') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 12
      WHERE lower(name) = lower('Fiamme gialle') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 13
      WHERE lower(name) = lower('Tess the rock princess') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 14
      WHERE lower(name) = lower('Marcello starman') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 15
      WHERE lower(name) = lower('Lemon squeezy') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 16
      WHERE lower(name) = lower('Crazy wedding') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 17
      WHERE lower(name) = lower('Il gusto della libertà') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 18
      WHERE lower(name) = lower('Contromisure') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 19
      WHERE lower(name) = lower('Je bande donc j''essui L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 20
      WHERE lower(name) = lower('Je bande donc j''essui L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 21
      WHERE lower(name) = lower('Arnaque') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 22
      WHERE lower(name) = lower('Il rutto') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 23
      WHERE lower(name) = lower('Krankenjura') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 24
      WHERE lower(name) = lower('Gregorian crowbar') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 25
      WHERE lower(name) = lower('Generale macchi') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 26
      WHERE lower(name) = lower('Cygnus') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 27
      WHERE lower(name) = lower('Python crack') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 28
      WHERE lower(name) = lower('Letz petz betz') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 29
      WHERE lower(name) = lower('Skyfall') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 30
      WHERE lower(name) = lower('Centenario') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 31
      WHERE lower(name) = lower('Sangue di cinghiale') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 32
      WHERE lower(name) = lower('Black eyed sky') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 33
      WHERE lower(name) = lower('Scuola alpina') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 34
      WHERE lower(name) = lower('Send and send ability') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 35
      WHERE lower(name) = lower('Climb and punishment') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 36
      WHERE lower(name) = lower('Lord of the slings') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 37
      WHERE lower(name) = lower('The grip of wrath') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 38
      WHERE lower(name) = lower('Henergy') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 39
      WHERE lower(name) = lower('Pale di San Martino') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 40
      WHERE lower(name) = lower('Ceci n''es pas une 8a') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 41
      WHERE lower(name) = lower('Deliverance') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 42
      WHERE lower(name) = lower('Providence') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 43
      WHERE lower(name) = lower('Thumbs up, nailed it') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 44
      WHERE lower(name) = lower('Mamma Miracoli') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 45
      WHERE lower(name) = lower('The bald and the beautiful') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 46
      WHERE lower(name) = lower('Cutting corners') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 47
      WHERE lower(name) = lower('About a poisonous snake') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 48
      WHERE lower(name) = lower('Pirate Bandit') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 49
      WHERE lower(name) = lower('Chumbawamba') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 50
      WHERE lower(name) = lower('Bokito') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 51
      WHERE lower(name) = lower('Sad little ego') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 52
      WHERE lower(name) = lower('Hot Marijke') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 53
      WHERE lower(name) = lower('Floki') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 54
      WHERE lower(name) = lower('Nanice') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 55
      WHERE lower(name) = lower('Wie ni waagt, ni klimt') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 56
      WHERE lower(name) = lower('Baciami subito') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 57
      WHERE lower(name) = lower('Plutonium') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 58
      WHERE lower(name) = lower('Rubamitutto') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 59
      WHERE lower(name) = lower('Rakomelo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 60
      WHERE lower(name) = lower('Come light my sick arête') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 61
      WHERE lower(name) = lower('Rattoncita') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 62
      WHERE lower(name) = lower('Nannaientists 4 ever') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 63
      WHERE lower(name) = lower('Alma') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 64
      WHERE lower(name) = lower('Women rock') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 65
      WHERE lower(name) = lower('Un have Maria') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 66
      WHERE lower(name) = lower('Accoglie la vi(t)a') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 67
      WHERE lower(name) = lower('Welcome to bambilon') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 68
      WHERE lower(name) = lower('Fight the fungus') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 69
      WHERE lower(name) = lower('Un attimo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 70
      WHERE lower(name) = lower('ROQS') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 71
      WHERE lower(name) = lower('Oempapa') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 72
      WHERE lower(name) = lower('Maria Loddo L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 73
      WHERE lower(name) = lower('Maria Loddo L1+L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 74
      WHERE lower(name) = lower('Spalla guarita') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 75
      WHERE lower(name) = lower('Hot Veerleken') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 76
      WHERE lower(name) = lower('Avanza con Costanza') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 77
      WHERE lower(name) = lower('Happy seratonin') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 78
      WHERE lower(name) = lower('#metoo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 79
      WHERE lower(name) = lower('Ogliastroman') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 80
      WHERE lower(name) = lower('The yellow king') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 81
      WHERE lower(name) = lower('Major Tom') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 82
      WHERE lower(name) = lower('Sgt. Hartman') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 83
      WHERE lower(name) = lower('Sylviaster Stallone') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 84
      WHERE lower(name) = lower('Ground control') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 85
      WHERE lower(name) = lower('Corner job') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 86
      WHERE lower(name) = lower('Kakbroekchef') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 87
      WHERE lower(name) = lower('I love bolting') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 88
      WHERE lower(name) = lower('Cometè L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 89
      WHERE lower(name) = lower('Cometè L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 90
      WHERE lower(name) = lower('Wallhalla') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 91
      WHERE lower(name) = lower('Le molle della vita') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 92
      WHERE lower(name) = lower('Korala') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 93
      WHERE lower(name) = lower('Luck Lucy') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 94
      WHERE lower(name) = lower('Furto allo stato') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 95
      WHERE lower(name) = lower('Juntos L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 96
      WHERE lower(name) = lower('Juntos L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 97
      WHERE lower(name) = lower('Juntos L3') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 98
      WHERE lower(name) = lower('Juntos L4') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 99
      WHERE lower(name) = lower('Pota tasinantable') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 100
      WHERE lower(name) = lower('Action indirect') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 101
      WHERE lower(name) = lower('Fessura Gangialf') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 102
      WHERE lower(name) = lower('Reddito di cittadinanza') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 103
      WHERE lower(name) = lower('Fagiolo magico') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 104
      WHERE lower(name) = lower('Punkabestia') AND sector_id = v_sector_id;
  ELSE
    RAISE WARNING 'Sector not found: % › %', 'Ulassai', 'Su Casteddu';
  END IF;

  -- Ulassai › Su Fundu
  SELECT s.id INTO v_sector_id
    FROM sectors s JOIN crags c ON c.id = s.crag_id
    WHERE lower(s.name) = lower('Su Fundu')
      AND lower(c.name) = lower('Ulassai')
    LIMIT 1;
  IF v_sector_id IS NOT NULL THEN
    UPDATE routes SET line_order = 1
      WHERE lower(name) = lower('Two jolly young goats') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 2
      WHERE lower(name) = lower('C&A') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 3
      WHERE lower(name) = lower('Momentum') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 4
      WHERE lower(name) = lower('Via dei piu cento') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 5
      WHERE lower(name) = lower('Porcahontas') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 6
      WHERE lower(name) = lower('Scoiattolo verzaschese') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 7
      WHERE lower(name) = lower('La mossa del fuorigioco') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 8
      WHERE lower(name) = lower('Amore mio') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 9
      WHERE lower(name) = lower('Aleci') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 10
      WHERE lower(name) = lower('Luka') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 11
      WHERE lower(name) = lower('Unting') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 12
      WHERE lower(name) = lower('Deck of 51') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 13
      WHERE lower(name) = lower('Gloria') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 14
      WHERE lower(name) = lower('Mira') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 15
      WHERE lower(name) = lower('Capezzoli al cielo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 16
      WHERE lower(name) = lower('Dammi il cinque') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 17
      WHERE lower(name) = lower('Dev''essere la colpa del karma') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 18
      WHERE lower(name) = lower('Sei forte papa') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 19
      WHERE lower(name) = lower('Scirocco') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 20
      WHERE lower(name) = lower('Flapjack') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 21
      WHERE lower(name) = lower('V10 people') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 22
      WHERE lower(name) = lower('Jan Steentjes L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 23
      WHERE lower(name) = lower('Jan Steentjes L1+L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 24
      WHERE lower(name) = lower('Nobody''s perfect to me L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 25
      WHERE lower(name) = lower('Nobody''s perfect to me L1+L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 26
      WHERE lower(name) = lower('The birthday party L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 27
      WHERE lower(name) = lower('The birthday party L1+L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 28
      WHERE lower(name) = lower('Dreadnaughtus L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 29
      WHERE lower(name) = lower('Dreadnaughtus L1+L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 30
      WHERE lower(name) = lower('Roccodomo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 31
      WHERE lower(name) = lower('Because I''m Batman') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 32
      WHERE lower(name) = lower('Principessa guerriera') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 33
      WHERE lower(name) = lower('Fanalista') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 34
      WHERE lower(name) = lower('Tom tom') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 35
      WHERE lower(name) = lower('"free it = name it"') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 36
      WHERE lower(name) = lower('Balls of steel') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 37
      WHERE lower(name) = lower('Steel fingers') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 38
      WHERE lower(name) = lower('Bianco nero') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 39
      WHERE lower(name) = lower('Grappa di Vincenzo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 40
      WHERE lower(name) = lower('Curly Wurly') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 41
      WHERE lower(name) = lower('Boys don''t cry') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 42
      WHERE lower(name) = lower('Rochefort 12') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 43
      WHERE lower(name) = lower('Il giorne delle firme') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 44
      WHERE lower(name) = lower('Gioia armata') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 45
      WHERE lower(name) = lower('Centenaria Jolien') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 46
      WHERE lower(name) = lower('Crag dominator') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 47
      WHERE lower(name) = lower('Crag director') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 48
      WHERE lower(name) = lower('Teardrops in paradise') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 49
      WHERE lower(name) = lower('Havoc & Rufus') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 50
      WHERE lower(name) = lower('Sus''pense') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 51
      WHERE lower(name) = lower('Tales of sus''pense') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 52
      WHERE lower(name) = lower('Tales of the rocking lizard') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 53
      WHERE lower(name) = lower('Il padrino di Tara') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 54
      WHERE lower(name) = lower('Falkor') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 55
      WHERE lower(name) = lower('Leaving on a jet plane') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 56
      WHERE lower(name) = lower('Nudo e crudo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 57
      WHERE lower(name) = lower('T-rex') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 58
      WHERE lower(name) = lower('Helejulia') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 59
      WHERE lower(name) = lower('The kitchen sink') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 60
      WHERE lower(name) = lower('Sletjetrek') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 61
      WHERE lower(name) = lower('Rhynoplasty') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 62
      WHERE lower(name) = lower('Riebedebie L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 63
      WHERE lower(name) = lower('Riebedebie L1+L2') AND sector_id = v_sector_id;
  ELSE
    RAISE WARNING 'Sector not found: % › %', 'Ulassai', 'Su Fundu';
  END IF;

  -- Ulassai › The Cave Theleme
  SELECT s.id INTO v_sector_id
    FROM sectors s JOIN crags c ON c.id = s.crag_id
    WHERE lower(s.name) = lower('The Cave Theleme')
      AND lower(c.name) = lower('Ulassai')
    LIMIT 1;
  IF v_sector_id IS NOT NULL THEN
    UPDATE routes SET line_order = 1
      WHERE lower(name) = lower('Gargantua') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 2
      WHERE lower(name) = lower('Pantagruel') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 3
      WHERE lower(name) = lower('Spike') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 4
      WHERE lower(name) = lower('Al sapore di rosmarino') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 5
      WHERE lower(name) = lower('Bacbuc') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 6
      WHERE lower(name) = lower('Charlie') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 7
      WHERE lower(name) = lower('a-Misc') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 8
      WHERE lower(name) = lower('The cave Theleme') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 9
      WHERE lower(name) = lower('Harlock') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 10
      WHERE lower(name) = lower('Mimi') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 11
      WHERE lower(name) = lower('Gordo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 12
      WHERE lower(name) = lower('Il ritorno del GPM') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 13
      WHERE lower(name) = lower('The nose') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 14
      WHERE lower(name) = lower('Brother Boi') AND sector_id = v_sector_id;
  ELSE
    RAISE WARNING 'Sector not found: % › %', 'Ulassai', 'The Cave Theleme';
  END IF;

  -- Ulassai › The Frame
  SELECT s.id INTO v_sector_id
    FROM sectors s JOIN crags c ON c.id = s.crag_id
    WHERE lower(s.name) = lower('The Frame')
      AND lower(c.name) = lower('Ulassai')
    LIMIT 1;
  IF v_sector_id IS NOT NULL THEN
    UPDATE routes SET line_order = 1
      WHERE lower(name) = lower('Andy Warhol') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 2
      WHERE lower(name) = lower('Pollock') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 3
      WHERE lower(name) = lower('Turner') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 4
      WHERE lower(name) = lower('Cézanne') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 5
      WHERE lower(name) = lower('Kandinsky') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 6
      WHERE lower(name) = lower('Picasso') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 7
      WHERE lower(name) = lower('Artemisia Gentileschi') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 8
      WHERE lower(name) = lower('Klimt') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 9
      WHERE lower(name) = lower('Mirò') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 10
      WHERE lower(name) = lower('William Blake') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 11
      WHERE lower(name) = lower('Gauguin') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 12
      WHERE lower(name) = lower('Frida Kahlo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 13
      WHERE lower(name) = lower('Caravaggio') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 14
      WHERE lower(name) = lower('Maria Lai') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 15
      WHERE lower(name) = lower('Goya') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 16
      WHERE lower(name) = lower('Foiso Fois') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 17
      WHERE lower(name) = lower('Leonardo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 18
      WHERE lower(name) = lower('Nivola') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 19
      WHERE lower(name) = lower('Ligabue') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 20
      WHERE lower(name) = lower('Escher') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 21
      WHERE lower(name) = lower('Paul Klee') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 22
      WHERE lower(name) = lower('Botticelli') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 23
      WHERE lower(name) = lower('Mondrian') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 24
      WHERE lower(name) = lower('Van Gogh') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 25
      WHERE lower(name) = lower('Salvador Dalì') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 26
      WHERE lower(name) = lower('Banksy') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 27
      WHERE lower(name) = lower('Sciola') AND sector_id = v_sector_id;
  ELSE
    RAISE WARNING 'Sector not found: % › %', 'Ulassai', 'The Frame';
  END IF;

  -- Ulassai › Torre dei Venti
  SELECT s.id INTO v_sector_id
    FROM sectors s JOIN crags c ON c.id = s.crag_id
    WHERE lower(s.name) = lower('Torre dei Venti')
      AND lower(c.name) = lower('Ulassai')
    LIMIT 1;
  IF v_sector_id IS NOT NULL THEN
    UPDATE routes SET line_order = 1
      WHERE lower(name) = lower('Tenendo per mano il sole') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 2
      WHERE lower(name) = lower('Catturando spiritelli') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 3
      WHERE lower(name) = lower('Diario intimo L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 4
      WHERE lower(name) = lower('Diario intimo L1+L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 5
      WHERE lower(name) = lower('Utopia') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 6
      WHERE lower(name) = lower('L''ala del vento') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 7
      WHERE lower(name) = lower('Tenendo per mano l''ombra') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 8
      WHERE lower(name) = lower('All''orizzonte azzurro') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 9
      WHERE lower(name) = lower('Al variar della luna') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 10
      WHERE lower(name) = lower('Ansia d''infinito') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 11
      WHERE lower(name) = lower('Maria Pietra L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 12
      WHERE lower(name) = lower('Maria Pietra L1+L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 13
      WHERE lower(name) = lower('Misurando l''infinito') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 14
      WHERE lower(name) = lower('Le parole prigioniere') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 15
      WHERE lower(name) = lower('Filando stupore nel cielo L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 16
      WHERE lower(name) = lower('Filando stupore nel cielo L1+L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 17
      WHERE lower(name) = lower('Lo scialle della luna') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 18
      WHERE lower(name) = lower('In vista di altri cieli') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 19
      WHERE lower(name) = lower('Ricucire il mondo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 20
      WHERE lower(name) = lower('La vela del cielo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 21
      WHERE lower(name) = lower('Il mondo incandescente') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 22
      WHERE lower(name) = lower('Mondo in fuga') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 23
      WHERE lower(name) = lower('Geografia') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 24
      WHERE lower(name) = lower('Cuore mio') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 25
      WHERE lower(name) = lower('Fiabe intrecciate') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 26
      WHERE lower(name) = lower('Mappa celeste') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 27
      WHERE lower(name) = lower('Foglie di memoria') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 28
      WHERE lower(name) = lower('Quanti mari navigare') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 29
      WHERE lower(name) = lower('Curiosape') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 30
      WHERE lower(name) = lower('La fuga della capretta') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 31
      WHERE lower(name) = lower('Il sasso') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 32
      WHERE lower(name) = lower('Il volo dell''oca') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 33
      WHERE lower(name) = lower('Creando spazi nuovi') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 34
      WHERE lower(name) = lower('Errando') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 35
      WHERE lower(name) = lower('Un filo nella notte L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 36
      WHERE lower(name) = lower('Un filo nella notte L1+L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 37
      WHERE lower(name) = lower('Robusta anima mia') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 38
      WHERE lower(name) = lower('La casa delle inquietudini') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 39
      WHERE lower(name) = lower('Sole scucito') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 40
      WHERE lower(name) = lower('Un mondo di trame') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 41
      WHERE lower(name) = lower('Dal segno allo spazio') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 42
      WHERE lower(name) = lower('Dal pane al sasso') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 43
      WHERE lower(name) = lower('La notte dei mondi scuciti') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 44
      WHERE lower(name) = lower('Storia universale') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 45
      WHERE lower(name) = lower('Verde coprente') AND sector_id = v_sector_id;
  ELSE
    RAISE WARNING 'Sector not found: % › %', 'Ulassai', 'Torre dei Venti';
  END IF;

  -- Ulassai › Vivendum
  SELECT s.id INTO v_sector_id
    FROM sectors s JOIN crags c ON c.id = s.crag_id
    WHERE lower(s.name) = lower('Vivendum')
      AND lower(c.name) = lower('Ulassai')
    LIMIT 1;
  IF v_sector_id IS NOT NULL THEN
    UPDATE routes SET line_order = 1
      WHERE lower(name) = lower('Calypso Queen') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 2
      WHERE lower(name) = lower('Ho munto come il porco') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 3
      WHERE lower(name) = lower('Fottonica') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 4
      WHERE lower(name) = lower('Una via Donato') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 5
      WHERE lower(name) = lower('Kip') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 6
      WHERE lower(name) = lower('Cut the balls') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 7
      WHERE lower(name) = lower('Astamborra') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 8
      WHERE lower(name) = lower('Minca se stamborra') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 9
      WHERE lower(name) = lower('Fingers in the dark') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 10
      WHERE lower(name) = lower('Il ritorno del filobus') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 11
      WHERE lower(name) = lower('Grow treviglio') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 12
      WHERE lower(name) = lower('Jump around') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 13
      WHERE lower(name) = lower('Jah Jah city') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 14
      WHERE lower(name) = lower('A sollazzare tra i monti') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 15
      WHERE lower(name) = lower('The Flokes van story') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 16
      WHERE lower(name) = lower('Huara guat') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 17
      WHERE lower(name) = lower('Acazzimma') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 18
      WHERE lower(name) = lower('Sargente Nathan') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 19
      WHERE lower(name) = lower('Vanity fair') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 20
      WHERE lower(name) = lower('Dark krystal') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 21
      WHERE lower(name) = lower('Effetto edera') AND sector_id = v_sector_id;
  ELSE
    RAISE WARNING 'Sector not found: % › %', 'Ulassai', 'Vivendum';
  END IF;

  -- Ulassai › Wallstreet
  SELECT s.id INTO v_sector_id
    FROM sectors s JOIN crags c ON c.id = s.crag_id
    WHERE lower(s.name) = lower('Wallstreet')
      AND lower(c.name) = lower('Ulassai')
    LIMIT 1;
  IF v_sector_id IS NOT NULL THEN
    UPDATE routes SET line_order = 1
      WHERE lower(name) = lower('K3') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 2
      WHERE lower(name) = lower('La proposta') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 3
      WHERE lower(name) = lower('Tilda') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 4
      WHERE lower(name) = lower('Le vent nous portera') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 5
      WHERE lower(name) = lower('Tunderpoo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 6
      WHERE lower(name) = lower('L''alpinista') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 7
      WHERE lower(name) = lower('Wilf') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 8
      WHERE lower(name) = lower('Grazie tante nonnine') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 9
      WHERE lower(name) = lower('Bellirisima') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 10
      WHERE lower(name) = lower('Stoneman') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 11
      WHERE lower(name) = lower('Slow pilot') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 12
      WHERE lower(name) = lower('Lorelei') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 13
      WHERE lower(name) = lower('Wallstreet of Antwerp') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 14
      WHERE lower(name) = lower('Beefy') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 15
      WHERE lower(name) = lower('Quicky and the beast') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 16
      WHERE lower(name) = lower('The wolf L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 17
      WHERE lower(name) = lower('The wolf L1+L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 18
      WHERE lower(name) = lower('Arezu') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 19
      WHERE lower(name) = lower('The lonely shephard') AND sector_id = v_sector_id;
  ELSE
    RAISE WARNING 'Sector not found: % › %', 'Ulassai', 'Wallstreet';
  END IF;

  -- Ussassai › Fundu 'e s'unturgiu
  SELECT s.id INTO v_sector_id
    FROM sectors s JOIN crags c ON c.id = s.crag_id
    WHERE lower(s.name) = lower('Fundu ''e s''unturgiu')
      AND lower(c.name) = lower('Ussassai')
    LIMIT 1;
  IF v_sector_id IS NOT NULL THEN
    UPDATE routes SET line_order = 1
      WHERE lower(name) = lower('Gli altri') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 2
      WHERE lower(name) = lower('Ragione e sentimento') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 3
      WHERE lower(name) = lower('Esodo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 4
      WHERE lower(name) = lower('Coso') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 5
      WHERE lower(name) = lower('The Swan') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 6
      WHERE lower(name) = lower('L''inizio della fine') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 7
      WHERE lower(name) = lower('Déjà vu') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 8
      WHERE lower(name) = lower('Sayid') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 9
      WHERE lower(name) = lower('Ben') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 10
      WHERE lower(name) = lower('Sawyer') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 11
      WHERE lower(name) = lower('La costante') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 12
      WHERE lower(name) = lower('Tre minuti') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 13
      WHERE lower(name) = lower('Piccolo Aaron') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 14
      WHERE lower(name) = lower('Volo 815') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 15
      WHERE lower(name) = lower('Katelegs') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 16
      WHERE lower(name) = lower('Fumonero') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 17
      WHERE lower(name) = lower('Mister Eko') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 18
      WHERE lower(name) = lower('Jacob') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 19
      WHERE lower(name) = lower('Flashforward') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 20
      WHERE lower(name) = lower('Sequenza numerica') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 21
      WHERE lower(name) = lower('Kahana') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 22
      WHERE lower(name) = lower('Barrette apollo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 23
      WHERE lower(name) = lower('Roccianera') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 24
      WHERE lower(name) = lower('L''equazione di Valenzetti') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 25
      WHERE lower(name) = lower('Jack Shephard') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 26
      WHERE lower(name) = lower('John Locke') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 27
      WHERE lower(name) = lower('Oceanic Six') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 28
      WHERE lower(name) = lower('Dharma') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 29
      WHERE lower(name) = lower('Hurley') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 30
      WHERE lower(name) = lower('Timeline') AND sector_id = v_sector_id;
  ELSE
    RAISE WARNING 'Sector not found: % › %', 'Ussassai', 'Fundu ''e s''unturgiu';
  END IF;

  -- Ussassai › Guglie di Niala
  SELECT s.id INTO v_sector_id
    FROM sectors s JOIN crags c ON c.id = s.crag_id
    WHERE lower(s.name) = lower('Guglie di Niala')
      AND lower(c.name) = lower('Ussassai')
    LIMIT 1;
  IF v_sector_id IS NOT NULL THEN
    UPDATE routes SET line_order = 1
      WHERE lower(name) = lower('Senza nome 1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 2
      WHERE lower(name) = lower('Far Est Story L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 3
      WHERE lower(name) = lower('Far Est Story L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 4
      WHERE lower(name) = lower('Far Est Story L3') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 5
      WHERE lower(name) = lower('Far Est Story L4') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 6
      WHERE lower(name) = lower('Tacchi a spillo L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 7
      WHERE lower(name) = lower('Tacchi a spillo L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 8
      WHERE lower(name) = lower('Tacchi a spillo L3') AND sector_id = v_sector_id;
  ELSE
    RAISE WARNING 'Sector not found: % › %', 'Ussassai', 'Guglie di Niala';
  END IF;

  -- Ussassai › Irtzioni
  SELECT s.id INTO v_sector_id
    FROM sectors s JOIN crags c ON c.id = s.crag_id
    WHERE lower(s.name) = lower('Irtzioni')
      AND lower(c.name) = lower('Ussassai')
    LIMIT 1;
  IF v_sector_id IS NOT NULL THEN
    UPDATE routes SET line_order = 1
      WHERE lower(name) = lower('Trempa orrubia') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 2
      WHERE lower(name) = lower('Mela ferru') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 3
      WHERE lower(name) = lower('Civargiu') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 4
      WHERE lower(name) = lower('Sartissu') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 5
      WHERE lower(name) = lower('Presuttu') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 6
      WHERE lower(name) = lower('Marandula') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 7
      WHERE lower(name) = lower('Casuagedu') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 8
      WHERE lower(name) = lower('Coccoi prena') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 9
      WHERE lower(name) = lower('Strippidi') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 10
      WHERE lower(name) = lower('Culurgioni L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 11
      WHERE lower(name) = lower('Culurgioni L1+L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 12
      WHERE lower(name) = lower('Trattalia L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 13
      WHERE lower(name) = lower('Trattalia L1+L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 14
      WHERE lower(name) = lower('Pani indorau') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 15
      WHERE lower(name) = lower('Orrubiolus') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 16
      WHERE lower(name) = lower('Pira molenti') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 17
      WHERE lower(name) = lower('Pira cambusina') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 18
      WHERE lower(name) = lower('Pira coscia') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 19
      WHERE lower(name) = lower('Pira buttinu') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 20
      WHERE lower(name) = lower('Mela titongia') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 21
      WHERE lower(name) = lower('Mel''ogliu') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 22
      WHERE lower(name) = lower('Pani e saba') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 23
      WHERE lower(name) = lower('Erda') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 24
      WHERE lower(name) = lower('Pani pintau') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 25
      WHERE lower(name) = lower('Friga tianu') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 26
      WHERE lower(name) = lower('Sambineddu') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 27
      WHERE lower(name) = lower('Acuardenti') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 28
      WHERE lower(name) = lower('Brodu di casu') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 29
      WHERE lower(name) = lower('Casue fitta L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 30
      WHERE lower(name) = lower('Casue fitta L1+L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 31
      WHERE lower(name) = lower('Casucottu') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 32
      WHERE lower(name) = lower('Capottu') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 33
      WHERE lower(name) = lower('Cagliadeddu') AND sector_id = v_sector_id;
  ELSE
    RAISE WARNING 'Sector not found: % › %', 'Ussassai', 'Irtzioni';
  END IF;

  -- Ferentillo › Gabbio
  SELECT s.id INTO v_sector_id
    FROM sectors s JOIN crags c ON c.id = s.crag_id
    WHERE lower(s.name) = lower('Gabbio')
      AND lower(c.name) = lower('Ferentillo')
    LIMIT 1;
  IF v_sector_id IS NOT NULL THEN
    UPDATE routes SET line_order = 1
      WHERE lower(name) = lower('Hey sei') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 2
      WHERE lower(name) = lower('Maledetti vi odio') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 3
      WHERE lower(name) = lower('Willy Love') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 4
      WHERE lower(name) = lower('Uomo civile') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 5
      WHERE lower(name) = lower('Portatore di tempesta') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 6
      WHERE lower(name) = lower('So Sexi') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 7
      WHERE lower(name) = lower('Die Hard') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 8
      WHERE lower(name) = lower('Totem') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 9
      WHERE lower(name) = lower('Corvo morto') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 10
      WHERE lower(name) = lower('Il corvo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 11
      WHERE lower(name) = lower('Malkuth') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 12
      WHERE lower(name) = lower('Jorgao') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 13
      WHERE lower(name) = lower('Kether') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 14
      WHERE lower(name) = lower('La danza dei dervisci') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 15
      WHERE lower(name) = lower('Capriccio') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 16
      WHERE lower(name) = lower('Nel buio') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 17
      WHERE lower(name) = lower('12') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 18
      WHERE lower(name) = lower('Calvizia') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 19
      WHERE lower(name) = lower('Troppa informazione') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 20
      WHERE lower(name) = lower('Linea Sottiletta') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 21
      WHERE lower(name) = lower('Il sentiero dei giganti') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 22
      WHERE lower(name) = lower('Bombardamentos L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 23
      WHERE lower(name) = lower('Bombardamentos L1+L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 24
      WHERE lower(name) = lower('La Maro del Pepi L1+L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 25
      WHERE lower(name) = lower('Alfredo Alfredo L1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 26
      WHERE lower(name) = lower('Black panthers L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 27
      WHERE lower(name) = lower('In un giorno di pioggia L2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 28
      WHERE lower(name) = lower('Polpastrillo') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 29
      WHERE lower(name) = lower('Tex mex') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 30
      WHERE lower(name) = lower('Zambia - Italia 4-0') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 31
      WHERE lower(name) = lower('Lo spigolo delle streghe') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 32
      WHERE lower(name) = lower('Viva Cuba') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 33
      WHERE lower(name) = lower('Senza nome 1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 34
      WHERE lower(name) = lower('Romeo 89') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 35
      WHERE lower(name) = lower('Il morbo di Ciato') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 36
      WHERE lower(name) = lower('Mandela superstar') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 37
      WHERE lower(name) = lower('The chinese way') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 38
      WHERE lower(name) = lower('Prosciuttini') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 39
      WHERE lower(name) = lower('Donne in amore') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 40
      WHERE lower(name) = lower('Rock a gay''n') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 41
      WHERE lower(name) = lower('Mumble mumble') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 42
      WHERE lower(name) = lower('Hare krisna') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 43
      WHERE lower(name) = lower('Yuk baluk') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 44
      WHERE lower(name) = lower('Fragole e sangue') AND sector_id = v_sector_id;
  ELSE
    RAISE WARNING 'Sector not found: % › %', 'Ferentillo', 'Gabbio';
  END IF;

  -- Miollet › Destro
  SELECT s.id INTO v_sector_id
    FROM sectors s JOIN crags c ON c.id = s.crag_id
    WHERE lower(s.name) = lower('Destro')
      AND lower(c.name) = lower('Miollet')
    LIMIT 1;
  IF v_sector_id IS NOT NULL THEN
    UPDATE routes SET line_order = 1
      WHERE lower(name) = lower('Petolla frolla') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 2
      WHERE lower(name) = lower('Masterplax') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 3
      WHERE lower(name) = lower('Tot dret') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 4
      WHERE lower(name) = lower('La ciociara') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 5
      WHERE lower(name) = lower('Harborea') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 6
      WHERE lower(name) = lower('Acquargento') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 7
      WHERE lower(name) = lower('Senza nome 1') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 8
      WHERE lower(name) = lower('Déjà vu') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 9
      WHERE lower(name) = lower('Il porco') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 10
      WHERE lower(name) = lower('La maiala') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 11
      WHERE lower(name) = lower('Fessurino') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 12
      WHERE lower(name) = lower('Intifada') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 13
      WHERE lower(name) = lower('Salonicco') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 14
      WHERE lower(name) = lower('La sfera') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 15
      WHERE lower(name) = lower('Infernalia') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 16
      WHERE lower(name) = lower('Senza nome 2') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 17
      WHERE lower(name) = lower('Senza nome 3') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 18
      WHERE lower(name) = lower('Senza nome 4') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 19
      WHERE lower(name) = lower('Senza nome 5') AND sector_id = v_sector_id;
    UPDATE routes SET line_order = 20
      WHERE lower(name) = lower('Senza nome 6') AND sector_id = v_sector_id;
  ELSE
    RAISE WARNING 'Sector not found: % › %', 'Miollet', 'Destro';
  END IF;

END $$;
-- Total: 1979 route updates
