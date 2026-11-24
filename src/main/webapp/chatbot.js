// ============================================
// JORINA CHATBOT - Assistant Immobilier
// ============================================

const chatbotResponses = {

    // ── Départements ──────────────────────────────────────────
    "departement": "Pour ajouter un département : Départements → + Ajouter → remplissez Nom, Adresse, Code Postal, Ville → Enregistrer.",
    "ajouter departement": "Départements → + Ajouter un département → remplissez le formulaire → Enregistrer.",
    "supprimer departement": "Dans la liste des Départements → cliquez le bouton 🗑 Supprimer → confirmez la suppression.",
    "modifier departement": "La modification d'un département n'est pas encore disponible. Supprimez et recréez-le avec les nouvelles informations.",

    // ── Appartements ──────────────────────────────────────────
    "appartement": "Pour ajouter un appartement : Appartements → + Ajouter → choisissez le département → remplissez Nom, Code, Étage, Prix → Enregistrer.",
    "ajouter appartement": "Appartements → + Ajouter → choisissez le département → remplissez les infos → Enregistrer.",
    "supprimer appartement": "Dans la liste des Appartements → cliquez 🗑 Supprimer sur l'appartement concerné → confirmez. Attention : les contrats liés seront aussi supprimés !",
    "modifier appartement": "La modification directe n'est pas disponible. Supprimez l'appartement et recréez-le avec les nouvelles informations.",
    "disponible": "Les appartements disponibles ont le statut 'disponible'. Allez dans Appartements pour voir la liste.",

    // ── Contrats ──────────────────────────────────────────────
    "contrat": "Pour créer un contrat : Contrats → + Nouveau contrat → choisissez appartement + locataire → dates + montants → Créer.",
    "ajouter contrat": "Contrats → + Nouveau contrat → choisissez appartement + locataire → dates + montants → Créer le contrat.",
    "supprimer contrat": "Dans la liste des Contrats → cliquez 🗑 Supprimer → confirmez. Attention : les factures liées seront aussi supprimées !",
    "modifier contrat": "La modification directe n'est pas disponible. Supprimez le contrat et recréez-le avec les nouvelles informations.",
    "resilier": "Pour résilier un contrat : dans la liste des Contrats → cliquez 🗑 Supprimer sur le contrat concerné.",

    // ── Factures ──────────────────────────────────────────────
    "facture": "Pour ajouter une facture : Factures → + Ajouter → choisissez le contrat → montant + date + type → Enregistrer.",
    "ajouter facture": "Factures → + Ajouter une facture → choisissez le contrat → montant + date → type (loyer/charges/caution) → Enregistrer.",
    "supprimer facture": "Dans la liste des Factures → cliquez 🗑 Supprimer sur la facture concernée → confirmez la suppression.",
    "modifier facture": "La modification directe n'est pas disponible. Supprimez la facture et recréez-la avec les bonnes informations.",
    "payer": "Pour marquer une facture comme payée : Factures → cliquez ✓ Payer sur la facture → le statut passe à Payée.",
    "payer facture": "Factures → trouvez la facture → cliquez le bouton ✓ Payer → statut devient Payée automatiquement.",
    "loyer": "Le loyer est une facture de type 'loyer'. Factures → + Ajouter → choisissez type Loyer.",
    "non payee": "Les factures non payées s'affichent avec le badge orange. Utilisez le filtre Statut → Non payée pour les voir.",
    "en retard": "Les factures en retard s'affichent avec le badge rouge. Utilisez le filtre Statut → En retard.",

    // ── Locataires ────────────────────────────────────────────
    "locataire": "Pour ajouter un locataire : Locataires → + Ajouter → remplissez Nom, Prénom, Email, Téléphone, CIN → rôle = locataire → Créer.",
    "ajouter locataire": "Locataires → + Ajouter → rôle = locataire → remplissez les infos → Créer le compte.",
    "supprimer locataire": "Dans la liste des Locataires → cliquez 🗑 Supprimer → confirmez. Attention : le locataire ne doit plus avoir de contrats actifs !",
    "modifier locataire": "La modification directe n'est pas disponible. Supprimez le locataire et recréez-le avec les nouvelles informations.",

    // ── Navigation ────────────────────────────────────────────
    "dashboard": "Le dashboard affiche : nombre de départements, appartements disponibles, contrats actifs et les dernières factures.",
    "menu": "Le menu contient : Dashboard, Départements, Appartements, Contrats, Factures, Locataires.",
    "statistique": "Les statistiques sont sur le Dashboard : total départements, appartements disponibles, contrats actifs.",

    // ── Actions générales ─────────────────────────────────────
    "supprimer": "Pour supprimer : trouvez l'élément dans sa liste → cliquez le bouton 🗑 Supprimer → confirmez dans la boîte de dialogue.",
    "modifier": "Pour modifier : supprimez l'élément existant → recréez-le avec les nouvelles informations.",
    "ajouter": "Pour ajouter : allez dans la page correspondante → cliquez le bouton + en haut à droite → remplissez le formulaire → Enregistrer.",
    "rechercher": "Utilisez les filtres disponibles dans chaque page pour filtrer par département, statut, contrat, etc.",
    "filtrer": "Des filtres sont disponibles dans Appartements (par département), Contrats (par appartement) et Factures (par statut et contrat).",

    // ── Aide générale ─────────────────────────────────────────
    "aide": `Je peux vous aider avec :
• Ajouter / Supprimer un département
• Ajouter / Supprimer un appartement  
• Ajouter / Supprimer un contrat
• Ajouter / Supprimer / Payer une facture
• Ajouter / Supprimer un locataire
Posez votre question !`,

    "bonjour": "Bonjour ! Je suis l'assistant Jorina. Comment puis-je vous aider ?",
    "hello": "Bonjour ! Je suis l'assistant Jorina. Comment puis-je vous aider ?",
    "salut": "Salut ! Comment puis-je vous aider avec la gestion immobilière ?",
    "merci": "De rien ! N'hésitez pas si vous avez d'autres questions.",
    "au revoir": "Au revoir ! Bonne gestion immobilière !",
};

// Réponse par défaut
const defaultResponse = "Je ne comprends pas. Essayez : 'ajouter appartement', 'supprimer contrat', 'payer facture', ou tapez 'aide' pour voir tout ce que je sais faire.";

// Trouver la meilleure réponse
function getBotResponse(message) {
    const msg = message.toLowerCase()
        .replace(/é|è|ê|ë/g, 'e')
        .replace(/à|â|ä/g, 'a')
        .replace(/î|ï/g, 'i')
        .replace(/ô|ö/g, 'o')
        .replace(/û|ü|ù/g, 'u')
        .replace(/ç/g, 'c')
        .trim();

    // Cherche la correspondance la plus longue d'abord
    let bestKey = null;
    let bestLength = 0;
    for (let key in chatbotResponses) {
        if (msg.includes(key) && key.length > bestLength) {
            bestKey = key;
            bestLength = key.length;
        }
    }
    return bestKey ? chatbotResponses[bestKey] : defaultResponse;
}

// Créer le HTML du chatbot
function createChatbot() {
    const chatHTML = `
        <!-- Bouton flottant -->
        <div id="chatbot-btn" onclick="toggleChat()"
             style="position:fixed;bottom:24px;right:24px;width:56px;height:56px;
                    background:#1a56db;border-radius:50%;cursor:pointer;
                    display:flex;align-items:center;justify-content:center;
                    box-shadow:0 4px 20px rgba(26,86,219,0.4);z-index:1000;
                    font-size:24px;transition:transform .2s;">
            💬
        </div>

        <!-- Fenêtre de chat -->
        <div id="chatbot-window"
             style="display:none;position:fixed;bottom:90px;right:24px;
                    width:340px;height:480px;background:#fff;border-radius:16px;
                    box-shadow:0 8px 40px rgba(0,0,0,0.15);z-index:1000;
                    flex-direction:column;overflow:hidden;">
 
            <!-- Header -->
            <div style="background:#1a56db;padding:16px 20px;
                        display:flex;align-items:center;justify-content:space-between;">
                <div style="display:flex;align-items:center;gap:10px;">
                    <div style="width:36px;height:36px;background:rgba(255,255,255,0.2);
                                border-radius:50%;display:flex;align-items:center;
                                justify-content:center;font-size:18px;">🏢</div>
                    <div>
                        <div style="color:#fff;font-weight:600;font-size:.95rem;">Assistant Jorina</div>
                        <div style="color:rgba(255,255,255,0.7);font-size:.75rem;">● En ligne</div>
                    </div>
                </div>
                <span onclick="toggleChat()"
                      style="color:#fff;cursor:pointer;font-size:1.3rem;opacity:0.8;">✕</span>
            </div>

            <!-- Suggestions rapides -->
            <div style="padding:8px 12px;background:#f0f4ff;border-bottom:1px solid #e5e7eb;
                        display:flex;gap:6px;flex-wrap:wrap;">
                <button onclick="quickMsg('ajouter appartement')"
                        style="padding:4px 10px;background:#fff;border:1px solid #1a56db;
                               border-radius:999px;font-size:.75rem;color:#1a56db;
                               cursor:pointer;">+ Appartement</button>
                <button onclick="quickMsg('supprimer contrat')"
                        style="padding:4px 10px;background:#fff;border:1px solid #1a56db;
                               border-radius:999px;font-size:.75rem;color:#1a56db;
                               cursor:pointer;">- Contrat</button>
                <button onclick="quickMsg('payer facture')"
                        style="padding:4px 10px;background:#fff;border:1px solid #1a56db;
                               border-radius:999px;font-size:.75rem;color:#1a56db;
                               cursor:pointer;">✓ Payer</button>
                <button onclick="quickMsg('aide')"
                        style="padding:4px 10px;background:#fff;border:1px solid #1a56db;
                               border-radius:999px;font-size:.75rem;color:#1a56db;
                               cursor:pointer;">Aide</button>
            </div>

            <!-- Messages -->
            <div id="chat-messages"
                 style="flex:1;overflow-y:auto;padding:16px;
                        display:flex;flex-direction:column;gap:10px;
                        background:#f8f9fc;">
                <div style="background:#fff;padding:10px 14px;
                            border-radius:4px 12px 12px 12px;
                            box-shadow:0 1px 4px rgba(0,0,0,0.08);
                            font-size:.85rem;color:#111827;max-width:90%;">
                    Bonjour ! Je suis l'assistant Jorina.<br>
                    Je peux vous aider avec l'ajout, la suppression et la gestion de vos biens.
                    Tapez <strong>aide</strong> pour voir tout ce que je sais faire !
                </div>
            </div>

            <!-- Input -->
            <div style="padding:12px;border-top:1px solid #e5e7eb;
                        display:flex;gap:8px;background:#fff;">
                <input id="chat-input" type="text"
                       placeholder="Tapez votre question..."
                       onkeypress="if(event.key==='Enter') sendMessage()"
                       style="flex:1;padding:9px 12px;border:1.5px solid #e5e7eb;
                              border-radius:8px;font-size:.875rem;outline:none;
                              font-family:inherit;transition:border-color .2s;"
                       onfocus="this.style.borderColor='#1a56db'"
                       onblur="this.style.borderColor='#e5e7eb'">
                <button onclick="sendMessage()"
                        style="padding:9px 14px;background:#1a56db;color:#fff;
                               border:none;border-radius:8px;cursor:pointer;
                               font-size:1rem;transition:background .2s;"
                        onmouseover="this.style.background='#1447b6'"
                        onmouseout="this.style.background='#1a56db'">➤</button>
            </div>
        </div>
    `;

    const div = document.createElement('div');
    div.innerHTML = chatHTML;
    document.body.appendChild(div);
}

// Suggestions rapides
function quickMsg(msg) {
    document.getElementById('chat-input').value = msg;
    sendMessage();
}

// Toggle chatbot
function toggleChat() {
    const win = document.getElementById('chatbot-window');
    const btn = document.getElementById('chatbot-btn');
    if (win.style.display === 'none' || win.style.display === '') {
        win.style.display = 'flex';
        btn.style.transform = 'scale(0.9)';
        document.getElementById('chat-input').focus();
    } else {
        win.style.display = 'none';
        btn.style.transform = 'scale(1)';
    }
}

// Envoyer message
function sendMessage() {
    const input = document.getElementById('chat-input');
    const message = input.value.trim();
    if (!message) return;

    const messages = document.getElementById('chat-messages');

    // Message utilisateur (droite)
    messages.innerHTML += `
        <div style="background:#1a56db;color:#fff;padding:10px 14px;
                    border-radius:12px 4px 12px 12px;
                    font-size:.85rem;max-width:90%;
                    align-self:flex-end;margin-left:auto;">
            ${message}
        </div>`;

    input.value = '';
    messages.scrollTop = messages.scrollHeight;

    // Indicateur "en train d'écrire..."
    const typingId = 'typing-' + Date.now();
    messages.innerHTML += `
        <div id="${typingId}" style="background:#fff;padding:10px 14px;
                    border-radius:4px 12px 12px 12px;
                    box-shadow:0 1px 4px rgba(0,0,0,0.08);
                    font-size:.85rem;color:#6b7280;max-width:90%;">
            ✍️ En train d'écrire...
        </div>`;
    messages.scrollTop = messages.scrollHeight;

    // Réponse après 700ms
    setTimeout(() => {
        const typing = document.getElementById(typingId);
        if (typing) typing.remove();

        const response = getBotResponse(message);
        messages.innerHTML += `
            <div style="background:#fff;padding:10px 14px;
                        border-radius:4px 12px 12px 12px;
                        box-shadow:0 1px 4px rgba(0,0,0,0.08);
                        font-size:.85rem;color:#111827;max-width:90%;
                        line-height:1.5;">
                ${response}
            </div>`;
        messages.scrollTop = messages.scrollHeight;
    }, 700);
}

// Initialiser
window.addEventListener('load', function() {
    createChatbot();
});