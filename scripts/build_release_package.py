from __future__ import annotations

import argparse
import hashlib
import subprocess
import tempfile
import zipfile
from pathlib import Path


EPOCH = (2020, 1, 1, 0, 0, 0)
PROJECT_FOLDER = "World_Mythology_System_v0.4.0_greek_genealogy"


def _sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def _write_member(archive: zipfile.ZipFile, name: str, data: bytes, *, executable: bool = False) -> None:
    info = zipfile.ZipInfo(name, EPOCH)
    info.compress_type = zipfile.ZIP_DEFLATED
    info.create_system = 0
    info.external_attr = (0o755 if executable else 0o644) << 16
    info.extra = b""
    archive.writestr(info, data)


def _tracked_files(project_root: Path) -> list[Path]:
    output = subprocess.check_output(
        ["git", "-C", str(project_root), "ls-files", "-z"],
    )
    return sorted(project_root / item.decode("utf-8") for item in output.split(b"\0") if item)


def _offline_web_files(project_root: Path) -> list[Path]:
    dist = project_root / "web" / "dist"
    if not (dist / "index.html").is_file():
        raise RuntimeError("web/dist is missing; run `cd web && npm run build` before packaging")
    return sorted(path for path in dist.rglob("*") if path.is_file())


def build(project_root: Path, output: Path, bundle: Path) -> dict[str, str]:
    database = project_root / "database" / "world_mythology.sqlite"
    checksums = {
        "World_Mythology_System_v0.4.0_greek_genealogy.git.bundle": _sha256(bundle),
        "world_mythology_v0.4.0.sqlite": _sha256(database),
    }
    start_here = (
        "世界神话系统 v0.4.0 希腊家谱版\n\n"
        "0. 先把整个 ZIP 解压到普通文件夹，不要直接在 ZIP 内运行。\n"
        "1. Windows 看网页：双击项目目录内的 START_WORLD_MYTHOLOGY.bat。\n"
        "2. macOS/Linux：运行 sh START_WORLD_MYTHOLOGY.sh。\n"
        "   启动后浏览器会打开 http://127.0.0.1:8765/；关闭终端即可停止。\n"
        "3. 开发模式：进入 web，运行 npm install，再运行 npm run dev。\n"
        "4. 数据库检查点位于 CHECKPOINTS/world_mythology_v0.4.0.sqlite。\n"
        "5. Git 检查点位于 CHECKPOINTS/World_Mythology_System_v0.4.0_greek_genealogy.git.bundle。\n"
        "6. GitHub 目标：https://github.com/darenyew7527/world-mythology-system\n\n"
        "这是可持续扩张的阶段性知识基线，不代表 ALL COMPLETE。\n"
    ).encode("utf-8")
    manifest = "".join(f"{digest}  {name}\n" for name, digest in sorted(checksums.items())).encode("utf-8")
    output.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.NamedTemporaryFile(dir=output.parent, prefix=f".{output.name}.", suffix=".tmp", delete=False) as handle:
        temporary_output = Path(handle.name)
    try:
        with zipfile.ZipFile(temporary_output, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=9) as archive:
            _write_member(archive, "从这里开始_START_HERE.txt", start_here)
            _write_member(archive, f"CHECKPOINTS/{bundle.name}", bundle.read_bytes())
            _write_member(archive, "CHECKPOINTS/world_mythology_v0.4.0.sqlite", database.read_bytes())
            _write_member(archive, "CHECKPOINTS/SHA256SUMS_v0.4.0.txt", manifest)
            for path in _tracked_files(project_root):
                relative = path.relative_to(project_root).as_posix()
                _write_member(archive, f"{PROJECT_FOLDER}/{relative}", path.read_bytes(), executable=relative.endswith(".sh"))
            for path in _offline_web_files(project_root):
                relative = path.relative_to(project_root).as_posix()
                _write_member(archive, f"{PROJECT_FOLDER}/{relative}", path.read_bytes())
        with zipfile.ZipFile(temporary_output) as archive:
            corrupt_member = archive.testzip()
            if corrupt_member:
                raise RuntimeError(f"Release ZIP verification failed at {corrupt_member}")
        temporary_output.replace(output)
        output.chmod(0o644)
    finally:
        temporary_output.unlink(missing_ok=True)
    return {"zip": str(output), "zip_sha256": _sha256(output), **checksums}


def main() -> None:
    parser = argparse.ArgumentParser(description="Build a metadata-normalized full release ZIP")
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--bundle", type=Path, required=True)
    args = parser.parse_args()
    project_root = Path(__file__).resolve().parents[1]
    result = build(project_root, args.output, args.bundle)
    for key, value in result.items():
        print(f"{key}={value}")


if __name__ == "__main__":
    main()
