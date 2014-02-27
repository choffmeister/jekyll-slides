# Kryptographische Hash Funktionen

---

# Hash Function

Eine Hashfunktion $h$ bildet einen Eingabewert $x$ beliebiger Länge auf einen Hashwert $y$ fester Länge ab.

$$ h : x \mapsto y = h(x) $$

---

# One-Way Hash Function (OWHF)

* Einwegfunktion: Zu gegeben Hashwert $y$ ist es (praktisch) unmöglich ein passendes $x$ mit $h(x) = y$ zu finden.
* Schwache Kollisionsresistenz: Zu gegebenem Eingabewert $x$ ist es (praktisch) unmöglich ein davon verschiedenes $x'$ zu finden, so dass $h(x) = h(x')$ gilt.

---

# Collision Resistant Hash Function (CRHF)

* Starke Kollisionsresistenz: Es ist (praktisch) unmöglich zwei verschiedene Eingabewerte $x$ und $x'$ zu finden, so dass $h(x) = h(x')$ gilt.

---

{% inline_svg images/fingerprint.svg scale='0.75' %}

---

# MD5 Hash Funktion

<table>
<tr>
  <td>$x$</td>
  <td><input id="md5-input" type="text" /></td>
</tr>
<tr>
  <td>$h(x)$</td>
  <td><input id="md5-output" type="text" readonly="readonly" /></td>
</tr>
</table>

---

# SHA1 Hash Funktion

<table>
<tr>
  <td>$x$</td>
  <td><input id="sha1-input" type="text" /></td>
</tr>
<tr>
  <td>$h(x)$</td>
  <td><input id="sha1-output" type="text" readonly="readonly" /></td>
</tr>
</table>
