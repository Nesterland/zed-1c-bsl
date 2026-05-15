//! 1C BSL — Zed WASM-расширение (v0.1.0)
//!
//! Обеспечивает автоматический запуск BSL Language Server для файлов `.bsl` и `.osl`.
//! Находит Java в системе, скачивает и кэширует bsl-language-server.jar, запускает LSP.

use std::path::PathBuf;
use zed_extension_api::{
    self as zed, Command, DownloadedFileType, GithubReleaseOptions, Result, Worktree,
};

/// GitHub-репозиторий BSL Language Server (формат "owner/repo")
const GITHUB_REPO: &str = "1c-syntax/bsl-language-server";

/// Имя JAR-файла в локальном кэше
const JAR_FILENAME: &str = "bsl-language-server.jar";

struct BslExtension {
    /// Кэшированный путь к Java-бинарнику (один раз ищем)
    java_path: Option<String>,
    /// Запомнили ли мы, что java не найдена
    java_not_found: bool,
}

impl BslExtension {
    /// Ищет java в системе: сначала JAVA_HOME, потом просто "java"
    fn find_java(&mut self) -> Result<String> {
        if let Some(ref path) = self.java_path {
            return Ok(path.clone());
        }
        if self.java_not_found {
            return Err(
                "Java not found. Install Java 17+ (JRE/JDK) and ensure it's in PATH or set JAVA_HOME."
                    .into(),
            );
        }

        // Проверяем JAVA_HOME: пробуем оба варианта имени бинарника
        if let Ok(java_home) = std::env::var("JAVA_HOME") {
            for java_name in &["java", "java.exe"] {
                let java_path = PathBuf::from(&java_home).join("bin").join(java_name);
                if java_path.exists() {
                    let path = java_path.to_string_lossy().to_string();
                    self.java_path = Some(path);
                    return Ok(self.java_path.clone().unwrap());
                }
            }
        }

        // Fallback: просто "java" — Zed сам найдёт в PATH при запуске процесса
        self.java_path = Some("java".into());
        Ok("java".into())
    }

    /// Возвращает путь к кэшированному JAR, при необходимости скачивая его
    fn ensure_jar(&self) -> Result<String> {
        // Кэш: сначала ZED_CACHE_DIR, потом ~/.cache/zed
        let cache_dir = std::env::var("ZED_CACHE_DIR")
            .map(PathBuf::from)
            .or_else(|_| {
                std::env::var("HOME").map(|home| {
                    let mut p = PathBuf::from(home);
                    p.push(".cache");
                    p.push("zed");
                    p
                })
            })
            .unwrap_or_else(|_| PathBuf::from("."));
        let jar_path = cache_dir.join("bsl-language-server").join(JAR_FILENAME);

        // Если JAR уже есть — возвращаем путь
        if jar_path.exists() {
            return Ok(jar_path.to_string_lossy().to_string());
        }

        // Создаём директорию кэша
        if let Some(parent) = jar_path.parent() {
            std::fs::create_dir_all(parent)
                .map_err(|e| format!("Failed to create cache dir: {e}"))?;
        }

        // Получаем последний релиз с GitHub
        let release = zed::latest_github_release(
            GITHUB_REPO,
            GithubReleaseOptions {
                require_assets: true,
                pre_release: false,
            },
        )?;

        // Ищем JAR-ассет
        let jar_asset = release
            .assets
            .iter()
            .find(|a| a.name.ends_with(".jar"))
            .ok_or_else(|| format!("No .jar asset found in latest release of {}", GITHUB_REPO))?;

        zed::download_file(
            &jar_asset.download_url,
            &jar_path.to_string_lossy(),
            DownloadedFileType::Uncompressed,
        )
        .map_err(|e| format!("Failed to download JAR: {e}"))?;

        Ok(jar_path.to_string_lossy().to_string())
    }
}

impl zed::Extension for BslExtension {
    fn new() -> Self {
        Self {
            java_path: None,
            java_not_found: false,
        }
    }

    fn language_server_command(
        &mut self,
        _language_server_id: &zed::LanguageServerId,
        _worktree: &Worktree,
    ) -> Result<Command> {
        let java = self.find_java()?;
        let jar = self.ensure_jar()?;

        Ok(Command {
            command: java,
            args: vec!["-Xmx2g".into(), "-jar".into(), jar],
            env: Vec::new(),
        })
    }
}

zed::register_extension!(BslExtension);
