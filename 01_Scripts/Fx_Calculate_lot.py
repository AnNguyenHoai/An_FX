# ==============================
# GRID BOT CALCULATOR (BE CORRECT + UNIT FIXED)
# ==============================

pip_value = 100  # 🔥 XAUUSD Exness


def simulate(v0, x, y, L1, L2, N):
    orders = []

    # ===== L1 =====
    for i in range(L1):
        d = i * x
        orders.append({"lot": v0, "distance": d})

    # ===== L2 =====
    for j in range(1, L2 + 1):
        price_j = (L1 - 1) * x + j * y

        # 🔥 FIX: BE đúng tại pullback = y
        loss = sum(
            o["lot"] * (price_j - y - o["distance"]) * pip_value
            for o in orders
        )

        vj = loss / (y * pip_value)

        orders.append({"lot": vj, "distance": price_j})

    # ===== DD tại N =====
    dd = sum(
        o["lot"] * (N - o["distance"]) * pip_value
        for o in orders if N > o["distance"]
    )

    return dd, orders


def find_v0(K, R, L1, L2, N):
    # ===== TÍNH x, y =====
    x = (R - 5 * L2) / (L1 + L2 - 1)
    y = x + 5

    if x <= 0:
        raise ValueError("❌ x <= 0 → tăng R hoặc giảm L2")

    # ===== BINARY SEARCH =====
    low, high = 0.000001, 10

    for _ in range(80):
        mid = (low + high) / 2
        dd, _ = simulate(mid, x, y, L1, L2, N)

        if dd > K / 4:
            high = mid
        else:
            low = mid

    v0 = low
    dd, orders = simulate(v0, x, y, L1, L2, N)

    return x, y, v0, orders, dd


def print_result(x, y, v0, orders, dd, K, N):
    print("\n========== RESULT ==========")
    print(f"x = {x:.4f}")
    print(f"y = {y:.4f}")
    print(f"v0 = {v0:.6f}")
    print(f"N = {N:.2f}")
    print(f"DD tại N = {dd:.2f} / {K/4:.2f}")

    print("\n========== ORDERS ==========")
    total_lot = 0
    for i, o in enumerate(orders, 1):
        total_lot += o["lot"]
        print(f"Lệnh {i:02d} | lot={o['lot']:.6f} | distance={o['distance']:.2f}")

    print("\n---------- SUMMARY ----------")
    print(f"Tổng số lệnh: {len(orders)}")
    print(f"Tổng lot: {total_lot:.2f}")
    print("-----------------------------")

    # ===== EXTRA =====
    last_distance = orders[-1]["distance"]
    extra = N - last_distance

    print("\n========== AFTER LAST ORDER ==========")
    print(f"Distance lệnh cuối = {last_distance:.2f}")
    print(f"Cần đi thêm = {extra:.2f} USD để đạt DD")


# ===== MAIN =====
if __name__ == "__main__":
    print("===== GRID BOT (BE CORRECT VERSION) =====")

    try:
        K = float(input("Vốn (K): "))
        R = float(input("Max range (R): "))
        L1 = int(input("Số lệnh L1: "))
        L2 = int(input("Số lệnh L2: "))
        N = float(input("Giá kiểm tra DD (N): "))

        x, y, v0, orders, dd = find_v0(K, R, L1, L2, N)

        print_result(x, y, v0, orders, dd, K, N)

    except Exception as e:
        print("❌ Lỗi:", e)