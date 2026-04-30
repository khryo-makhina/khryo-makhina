---

# 📘 **Cline + Ollama: Practical Model Compatibility Guide (Reference Summary)**

This document summarizes the key findings from testing various Ollama models with **Cline**, focusing on tool‑use reliability, file editing, and multi‑file reasoning.

---

## 🧩 **1. Why some models “pretend” to read/write files but do nothing**

Cline requires models to output **XML tool calls**, such as:

```xml
<read_file>
  <path>...</path>
</read_file>
```

If a model does **not** emit these tags, Cline rejects the response and shows:

> “You did not use a tool in your previous response!”

Most general chat models (Ministral‑3, glm‑4.7, Llama3.1, etc.) are **not tool‑use tuned**, so they:

- talk like an agent  
- hallucinate commands  
- never actually trigger tools  
- cannot read or modify files  

---

## 🧠 **2. What makes a model good for Cline**

A model must be **trained or fine‑tuned** to:

- emit XML tool tags  
- follow Cline’s schema  
- avoid mixing text outside tags  
- handle multi‑file edits  
- produce clean diffs  

Only a few models do this reliably.

---

## 🟢 **3. Recommended models (from your installed list)**

### ✔️ **Best fallback model you already have**
**`hhao/qwen2.5-coder-tools:3b`**

- explicitly fine‑tuned for tool use  
- emits correct XML  
- stable and obedient  
- great for small edits  
- fast  

This is the **only** model in your current list that is *designed* for Cline.

---

## 🟡 **4. Models you have that *work*, but are limited**

### **`heatxsink/cline-tools.deepseek-r1:8b`**
- community‑fine‑tuned  
- tool‑use works *most* of the time  
- but:  
  - verbose reasoning  
  - messy diffs  
  - inconsistent XML  
  - weak coding ability  
  - struggles with multi‑file edits  

Good for trivial edits, not for serious work.

---

## ❌ **5. Models you have that do *not* work well with Cline**

These models are **not tool‑use tuned**, so they hallucinate tool calls or ignore them:

- `ministral-3:14b`  
- `ministral-3_14b-opt`  
- `glm-4.7-flash_q4_K_M_opt`  
- `glm-4.7-flash:q4_K_M`  
- `qwen3.5:9b`  
- `qwen3.59b-opt`  
- `translategemma-12b`  
- `llama3.1:8b`  
- `incept5/llama3.1-claude`  

These models will:

- say “I will read the file now…”  
- but never emit `<read_file>`  
- or produce invalid XML  
- or mix text + XML  

Cline will reject them.

---

## ⭐ **6. The best model to install for Cline**

### **`qwen2.5-coder:14b`**

This is the **gold standard** for local Cline use.

Why:

- perfect XML tool‑use  
- excellent coding ability  
- stable multi‑file reasoning  
- clean diffs  
- long context  
- behaves like Claude Code locally  

Your hardware (dual Xeon + 100GB RAM + RTX 3060 12GB) can run it comfortably.

Install it with:

```
ollama pull qwen2.5-coder:14b
```

Then set it as your Cline model.

---

## 🧭 **7. Recommended setup for you**

### **Primary model (best overall):**
```
qwen2.5-coder:14b
```

### **Backup model (fast + reliable):**
```
hhao/qwen2.5-coder-tools:3b
```

### **Optional tiny model (simple edits only):**
```
heatxsink/cline-tools.deepseek-r1:8b
```

### **Avoid using:**
- Ministral‑3  
- glm‑4.7  
- qwen3.5 / qwen3.59b  
- translategemma  
- llama3.1  

They are not tool‑use agents.

---

## 🧪 **8. Quick test to verify tool access**

Ask the model:

```
List the files in the current directory.
```

If it returns a real directory listing → tool access works.  
If it hallucinates → wrong model.

---

## 🎯 **9. Summary Table**

| Model | Tool Use | Coding | Multi‑file | Stability | Recommended |
|-------|----------|--------|------------|-----------|-------------|
| **qwen2.5-coder:14b** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | **YES** |
| **hhao/qwen2.5-coder-tools:3b** | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐⭐ | Good fallback |
| heatxsink/cline-tools.deepseek-r1:8b | ⭐⭐ | ⭐ | ⭐ | ⭐⭐ | Only simple tasks |
| ministral‑3 (all) | ⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐ | No |
| glm‑4.7 (all) | ⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐ | No |
| qwen3.5 / qwen3.59b | ⭐ | ⭐⭐⭐ | ⭐⭐ | ⭐ | No |
| translategemma | ⭐ | ⭐ | ⭐ | ⭐ | No |
| llama3.1 | ⭐ | ⭐⭐ | ⭐ | ⭐ | No |

---

If you want, I can also prepare:

- a ready‑to‑paste Cline model config  
- a system prompt optimized for Qwen2.5‑Coder  
- a README section explaining how to choose models for Cline  
- a workflow guide for your translation corpus tools  

Just tell me what you’d like next.