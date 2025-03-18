final: prev: {
  talon = final.callPackage (
    { lib, stdenv, fetchzip, fetchurl, steam-run, makeWrapper, undmg }:

    let
      # Define platform-specific values
      platformData = if stdenv.isDarwin then {
        url = "https://talonvoice.com/dl/latest/talon-mac.dmg";
        sha256 = "sha256-QC+LSsFy2XNg47YMN1PmUr2sxAj5K3lUf5bDThrLZ70=";
        fetcher = fetchurl;
      } else {
        url = "https://talonvoice.com/dl/latest/talon-linux.tar.xz";
        sha256 = "sha256-j3D2Tzlm+au6E8Y+XLAMPnGFk9zUz3znjjeAzY7AIHU=";
        fetcher = fetchzip;
      };
    in
    stdenv.mkDerivation rec {
      pname = "talon";
      version = "0.4.0";
      
      src = platformData.fetcher {
        inherit (platformData) url sha256;
      };

      nativeBuildInputs = [ makeWrapper ] ++ lib.optionals stdenv.isDarwin [ undmg ];
      
      dontBuild = true;
      dontPatchELF = true;

      unpackPhase = if stdenv.isDarwin then ''
        undmg $src
      '' else ''
        unpackPhase
      '';

      installPhase = if stdenv.isDarwin then ''
        mkdir -p $out/Applications
        cp -a *.app $out/Applications/
        mkdir -p $out/bin
        makeWrapper "$out/Applications/Talon.app/Contents/MacOS/talon" "$out/bin/talon"
      '' else ''
        mkdir -p $out/bin
        cp -a * $out
      '';

      fixupPhase = if stdenv.isDarwin then "" else ''
        sed -i '4,8d' $out/run.sh
        makeWrapper ${steam-run}/bin/steam-run $out/bin/talon --add-flags $out/run.sh 
      '';
      
      meta = with lib; {
        description = "Talon voice control system";
        platforms = platforms.linux ++ platforms.darwin;
        maintainers = with maintainers; [ lessuselesss ];
      };
    }
  ) {};
} 

# ai_voice_commands.talon

# # Direct commands to providers with text
# ask <user.ai_providers> <user.text>: user.talk_to_provider(ai_providers, text, true)
# voice <user.ai_providers> <user.text>: user.talk_to_provider(ai_providers, text, false)

# # Start dictation/voice chat mode
# dictate to <user.ai_providers>: user.talk_to_provider(ai_providers, None, true)
# chat with <user.ai_providers>: user.talk_to_provider(ai_providers, None, false)

# # Stop dictation
# stop dictating: user.stop_dictation()
# end chat: user.stop_dictation()

# # Commands active during dictation
# tag: user.ai_dictation_active
# -
# <phrase>: user.send_dictation(phrase)
# submit: user.stop_dictation()

# ai_voice_router.py 

# from talon import Module, Context, actions, settings, app
# import json
# import threading

# mod = Module()
# mod.tag("ai_dictation_active", desc="Tag for when AI dictation is active")

# # Define our providers
# mod.list("ai_providers", desc="List of AI and voice assistant providers")
# mod.setting("ai_providers_config", type=str, 
#     default='''{
#         "chatgpt": {"type": "ai", "module": "talon_ai_chat"},
#         "claude": {"type": "ai", "module": "talon_ai_chat"},
#         "siri": {"type": "assistant", "platform": "mac"},
#         "google": {"type": "assistant", "platform": "all"},
#         "alexa": {"type": "assistant", "platform": "all"}
#     }''', 
#     desc="Configuration for AI and voice assistant providers")

# # State tracking
# active_provider = None
# dictation_mode = True  # True for text, False for voice
# dictation_active = False

# # Try to import talon_ai_chat
# try:
#     import talon_ai_chat
#     has_ai_chat = True
# except ImportError:
#     has_ai_chat = False
#     print("Note: talon_ai_chat module not found. Some AI features will be limited.")

# @mod.capture(rule="{user.ai_providers}")
# def ai_providers(m) -> str:
#     "Returns the selected AI provider"
#     return m.ai_providers

# @mod.action_class
# class Actions:
#     def talk_to_provider(provider: str, text: str = None, use_dictation: bool = True):
#         """Talk to the specified AI provider using either dictation or voice"""
#         global active_provider, dictation_mode, dictation_active
        
#         # Load provider configuration
#         try:
#             providers_config = json.loads(settings.get("user.ai_providers_config"))
#         except Exception as e:
#             actions.user.notify(f"Error loading provider config: {str(e)}")
#             return
            
#         if provider not in providers_config:
#             actions.user.notify(f"Unknown provider: {provider}")
#             return
            
#         provider_config = providers_config[provider]
#         provider_type = provider_config.get("type", "unknown")
        
#         # Set the active provider and mode
#         active_provider = provider
#         dictation_mode = use_dictation
        
#         # If text is provided, send it immediately
#         if text:
#             send_to_provider(provider, text, use_dictation)
#             return
            
#         # Otherwise, start dictation mode
#         dictation_active = True
#         ctx.tags = ["user.ai_dictation_active"]
#         actions.user.notify(f"Dictating to {provider}" if use_dictation else f"Voice chat with {provider}")
    
#     def stop_dictation():
#         """Stop the active dictation session"""
#         global dictation_active
#         dictation_active = False
#         ctx.tags = []
#         actions.user.notify("Dictation stopped")
    
#     def send_dictation(text: str):
#         """Send dictated text to the active provider"""
#         global active_provider, dictation_mode
#         if not active_provider or not dictation_active:
#             return
            
#         send_to_provider(active_provider, text, dictation_mode)

# # Helper functions
# def send_to_provider(provider: str, text: str, use_dictation: bool):
#     """Send the text or voice to the specified provider"""
#     try:
#         providers_config = json.loads(settings.get("user.ai_providers_config"))
#         provider_config = providers_config.get(provider, {})
#         provider_type = provider_config.get("type", "unknown")
        
#         if provider_type == "ai":
#             send_to_ai_provider(provider, text)
#         elif provider_type == "assistant":
#             send_to_voice_assistant(provider, text)
#         else:
#             actions.user.notify(f"Unknown provider type: {provider_type}")
#     except Exception as e:
#         actions.user.notify(f"Error sending to provider: {str(e)}")

# def send_to_ai_provider(provider: str, text: str):
#     """Send text to an AI provider"""
#     if not has_ai_chat:
#         actions.user.notify(f"Cannot send to {provider}: talon_ai_chat not installed")
#         return
        
#     if provider == "chatgpt":
#         talon_ai_chat.send_to_chatgpt(text)
#     elif provider == "claude":
#         talon_ai_chat.send_to_claude(text)
#     else:
#         actions.user.notify(f"Unknown AI provider: {provider}")

# def send_to_voice_assistant(assistant: str, text: str):
#     """Send text to a voice assistant"""
#     if assistant == "siri":
#         if app.platform == "mac":
#             actions.key("cmd-space")
#             actions.sleep("0.5")
#             actions.insert(text)
#             actions.key("enter")
#         else:
#             actions.user.notify("Siri only available on macOS")
    
#     elif assistant == "google":
#         # Simulate "Hey Google" with keyboard shortcut or app activation
#         if app.platform == "mac":
#             # This is placeholder - adjust for your system
#             actions.user.notify(f"Sending to Google Assistant: {text}")
#             # actions.key("cmd-shift-g")  # Example shortcut
#             # actions.sleep("0.5")
#             # actions.insert(text)
    
#     elif assistant == "alexa":
#         # Placeholder for Alexa integration
#         actions.user.notify(f"Sending to Alexa: {text}")

# # Initialize context and provider list
# ctx = Context()

# # Update the provider list based on the configuration
# def update_provider_list():
#     try:
#         providers_config = json.loads(settings.get("user.ai_providers_config"))
#         ctx.lists["user.ai_providers"] = {name: name for name in providers_config.keys()}
#     except Exception as e:
#         print(f"Error updating provider list: {str(e)}")

# app.register("ready", update_provider_list)

#
# # settings.talon
#

# AI provider configuration
# settings():
#     user.ai_providers_config = '''
#     {
#         "chatgpt": {
#             "type": "ai",
#             "module": "talon_ai_chat",
#             "api_key": "your_openai_key_here"
#         },
#         "claude": {
#             "type": "ai", 
#             "module": "talon_ai_chat",
#             "api_key": "your_anthropic_key_here"
#         },
#         "siri": {
#             "type": "assistant",
#             "platform": "mac"
#         },
#         "google": {
#             "type": "assistant",
#             "platform": "all",
#             "app_path": "/path/to/google/assistant"
#         },
#         "alexa": {
#             "type": "assistant",
#             "platform": "all"
#         },
#         "bard": {
#             "type": "ai",
#             "module": "custom",
#             "api_endpoint": "https://your-bard-endpoint"
#         }
#     }
#     '''